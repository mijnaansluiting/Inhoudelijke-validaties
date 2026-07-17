---
type: Decision
title: Memoized geometry parsing (ma:parse-point/ma:parse-line/ma:parse-area)
description: Why parsing a geometry's raw GML coordinate string is now cached per node instead of redone on every call, and why R.21 was the dominant remaining cost the connectivity-index fix didn't touch.
tags: decision, performance, geometry
timestamp: 2026-07-10T00:00:00Z
published: true
editor: markdown
date: 2026-07-10T00:00:00Z
dateCreated: 2026-07-10T00:00:00Z
---

# Context

Follow-on to [connectivity-index-and-geometry-caching](./connectivity-index-and-geometry-caching),
which cut `benchmark.xml` (the stress-test fixture) from 132s to ~27s by
building one shared mof/kabel touch index instead of 6 duplicated
brute-force scans. That decision explicitly left `ma:parse-point`/
`ma:parse-line`/`ma:parse-area` (in
[helper_functions.xsl](../architecture/xsl-function-libraries)) unmodified,
noting they're "called by all 41 rules, not just these 6" — too broad a
blast radius for that pass.

Investigating a proposal to add a quad tree for the remaining
[R.20](../rules/R.20)/[R.22](../rules/R.22)/[R.23](../rules/R.23)/
[R.25](../rules/R.25)/[R.26](../rules/R.26)/[R.39](../rules/R.39)
points×lines cost surfaced a bigger, cheaper, unrelated problem first:
`ma:parse-point`/`ma:parse-line`/`ma:parse-area` re-tokenize the raw GML
coordinate string and rebuild a fresh `<Coord>` element per vertex on
*every single call*, with zero memoization of the parse itself — only the
final touch/connectivity *result* was ever cached.

# Root cause

Auditing every call site (only 5 abstract patterns plus
`connectivity_functions.xsl` call these functions directly — `geometry_functions.xsl`'s
functions all take already-parsed nodes, so the blast radius is smaller than
the "all 41 rules" concern above suggested):

- [R.21](../rules/R.21) (`geldig_eindpunt_kabel.sch`) — **the dominant cost**.
  For every `MSkabel`/`LSkabel`/`Eaarddraad`, it re-parses every candidate
  `MSmof`/`MSoverdrachtspunt`/`MSstation`/etc. geometry twice (once for the
  start point check, once for the end point) via `some $x_geometry in
  //nlcs:Xxx/nlcs:Geometry satisfies ma:point-connected-to-point(...,
  ma:parse-point($x_geometry))` — true O(kabels × moffen) reparsing, never
  covered by the connectivity index (R.21 checks point-to-point coincidence,
  a structurally different relationship, and was deliberately left alone by
  that decision).
- `connectivity_functions.xsl` itself re-parses every candidate line's
  geometry for every point while building its touch index — O(points ×
  lines) reparses, on top of the O(points × lines) bbox/segment comparisons
  already accounted for.
- [R.3](../rules/R.3), [R.4](../rules/R.4), [R.36](../rules/R.36)
  re-parse a geometry once per rule instance/candidate — smaller
  contributors but the same underlying gap.

# Decision

Wrapped `ma:parse-point`/`ma:parse-line`/`ma:parse-area` in
[helper_functions.xsl](../architecture/xsl-function-libraries) with three
lazily-evaluated global XPath 3.1 maps (`parsed_point_cache`,
`parsed_line_cache`, `parsed_area_cache`), each keyed by `generate-id()` of
the `nlcs:Geometry` node and built once per validation run by scanning all
geometries of the matching shape (`gml:Point`/`gml:LineString`/`gml:Polygon`).
The three public functions now do a single `map:get(...)` instead of
re-tokenizing and rebuilding the `Coord*` tree.

Function signatures are unchanged (still take a geometry node, still return
the same parsed node sequence), so **no `.sch` abstract pattern needed to
change** — the blast radius is one file, despite the functions being used by
11 rules in total (R.3, R.4-A, R.4-B, R.21, R.36 directly; R.20/22/23/25/26/39
transitively via `connectivity_functions.xsl`).

Followed the same pure-map style connectivity_functions.xsl already
established — `<map>`/`<map-entry>` construction, no constructed element
tree indexed via `xsl:key` for the cache itself — since that combination
previously caused a real Saxon lazy-evaluation defect at ~142k-pair scale
(see that decision's "Why maps instead of a constructed tree" section). Every
geometry node passed to these functions was confirmed (by reading every call
site) to always be a real, stable source-document node, never synthetic, so
`generate-id()` is a safe cache key.

# Verification

- All 41 rules' `passing`/`failing` fixtures under
  [rule-test-fixtures](../testing/rule-test-fixtures)
  (`scripts/transpile_phases.sh` + `scripts/validate_rules.sh` +
  `scripts/validate_rule_reports.sh`) produced identical PASS/FAIL before
  and after.
- [coverage-checks](../testing/coverage-checks)
  (`check_rule_coverage.sh`, `check_rule_object_coverage.sh`): zero
  mismatches.
- `benchmark.sh` against `benchmark.xml`: **~27s → 10s** (consistent across
  repeated runs), with the resulting SVRL report containing the identical
  7389 `failed-assert`/`successful-report` elements as the pre-change
  baseline (`report.svrl.xml`) — same findings, ~2.7x faster.

# Relation to spatial indexing (quad tree)

This fix was prioritized ahead of a proposed quad tree for the
points×lines connectivity-index cost, since a spatial index only prunes
*which* lines get compared to a point — it doesn't touch the fact that every
candidate's geometry was being fully re-tokenized and rebuilt on every
comparison. With parsing now O(1) amortized per geometry, the residual
points×lines comparison cost (the one thing a quad tree/grid would target)
is much smaller than it was; whether it's still worth a spatial index should
be re-assessed against the new 10s baseline rather than the old 27s one.

# Citations

[1] [helper_functions.xsl](../../validation_schemas/xsl_functions/helper_functions.xsl)
[2] [geldig_eindpunt_kabel.sch](../../validation_schemas/abstract_patterns/v12/topologie/geldig_eindpunt_kabel.sch)
[3] [connectivity-index-and-geometry-caching](./connectivity-index-and-geometry-caching)
[4] [benchmark.xml / benchmark.sh / report.svrl.xml (stress-test fixture, harness, and resulting SVRL report — not part of the committed rule test suite)](../../benchmark.sh)
