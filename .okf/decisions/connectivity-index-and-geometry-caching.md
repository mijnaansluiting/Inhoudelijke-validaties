---
type: Decision
title: Shared connectivity index and geometry caching for mof/kabel touch checks
description: Why R.20, R.22, R.23, R.25, R.26, and R.39 now share one precomputed touch index instead of each doing its own brute-force geometry scan.
tags: decision, performance, geometry
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../validation_schemas/xsl_functions/connectivity_functions.xsl"
    title: "connectivity_functions.xsl"
  - resource: "../../benchmark.sh"
    title: "benchmark.xml / benchmark.sh (stress-test fixture and harness, not part of the committed rule test suite)"
---

# Context

A stress-test file (`benchmark.xml`: 286 LSkabel, 251 LSmof, 136
LSoverdrachtspunt, 99 OVLoverdrachtspunt, 7 MSkabel; geometries averaging ~32
vertices, one line with ~593) took **132 seconds** to validate under
"Bestaande Situatie" — far too slow for a single file. An earlier, separate
fix to [xsl-function-libraries](../architecture/xsl-function-libraries)'s
`geometry_functions.xsl` (rounding/line-buffer precision work, unrelated to
this decision) had already cut that from an even higher baseline; this
decision covers a second, structural fix.

Profiling pointed at [R.20](../rules/R.20), [R.22](../rules/R.22),
[R.23](../rules/R.23), [R.25](../rules/R.25), and [R.26](../rules/R.26) —
plus [R.39](../rules/R.39), found to share the identical pattern during
this investigation — as the dominant cost, all built on `ma:point-touches-line`.

# Root causes

Reading every abstract pattern that calls `ma:point-touches-line`/
`ma:parse-line`/`ma:parse-point` (in `helper_functions.xsl`/
`geometry_functions.xsl`) surfaced two compounding problems:

1. **No caching.** `ma:parse-line`/`ma:parse-point` re-tokenize the raw GML
   coordinate string and rebuild a fresh element tree on *every* call. Every
   rule invoked them inside a per-context-node predicate that rescans the
   whole candidate population, so the same object's geometry was rebuilt
   thousands of times per run.
2. **No shared "which kabels does this mof touch" index.** R.20, R.22, R.23,
   R.25, R.26, and R.39 each independently brute-force scanned
   `//nlcs:MSkabel`/`//nlcs:LSkabel` for every mof/overdrachtspunt. Since
   `benchmark.sh` runs the full combined schema (all phases in one
   stylesheet — see [compilation-pipeline](../architecture/compilation-pipeline)),
   this identical relationship was recomputed 6 separate times per run.
   R.22 and R.23 additionally **nested** the scan: for every kabel, find
   connected moffen, then re-scan *all* cables again per connected mof —
   effectively O(cables² × moffen-per-cable).

# Decision

Added `validation_schemas/xsl_functions/connectivity_functions.xsl`
(see [xsl-function-libraries](../architecture/xsl-function-libraries)),
computed lazily once per validation run and reused by all 6 rules:

- Each covered object's geometry (`MSmof`/`LSmof`/`Eaardmof`/
  `MSoverdrachtspunt`/`LSoverdrachtspunt`/`OVLoverdrachtspunt` on the point
  side; `MSkabel`/`LSkabel`/`HSkabel`/`Eaarddraad` on the line side) is
  parsed exactly once.
- The touch relationship is represented as **two XPath 3.1 maps** —
  `mof-id -> touching kabel-ids` and its inverse — rather than a constructed
  element tree indexed via `xsl:key`. The inverse is derived from the
  forward map with `map:merge(..., map{'duplicates':'combine'})` instead of
  re-running the geometry scan a second time.
- Three public functions replace every rule's inline brute-force predicate:
  `ma:touching-kabels($point)`, `ma:touching-moffen($kabel)`, and
  `ma:touching-kabels-via-moffen($moffen, $kabel_type)` (the "second hop"
  R.22/R.23 need — composes two O(1)-ish map lookups instead of a nested
  full-document rescan).
- R.20, R.22, R.23, R.25, R.26, and R.39's abstract patterns were rewritten
  to call these functions. Every `<assert>` test/message is byte-for-byte
  unchanged — only the source of each `$connected_*` variable changed.

This eliminates the ×6 duplicated computation (built once instead of once
per rule) and replaces R.22/R.23's O(cables² × moffen) nested rescan with
O(1)-ish composed lookups, without changing what any rule actually checks.

# Why maps instead of a constructed tree + `xsl:key`

The first implementation represented the touch table as constructed
`<Touch mof_id="..." kabel_id="..." kabel_type="..."/>` elements, indexed via
`xsl:key` — the more "obvious" XSLT idiom, and consistent with how
[rule_scope_functions.xsl](../architecture/xsl-function-libraries) already
uses a top-level `document()`-backed variable. It worked correctly in
isolated tests (a minimal stylesheet including just the geometry/config/
helper/connectivity libraries) but **intermittently failed once compiled
into the full 41-rule schema** and run against the ~142,000-pair cross
product (486 points × 293 lines), with a Saxon error claiming an empty
sequence where a point or line node was expected.

This was tracked down to a genuine Saxon lazy/tail-call evaluation defect,
not a logic bug: wrapping every individual pair's check in `xsl:try`/
`xsl:catch` and re-running all ~142,000 pairs produced **zero** real
failures — every pair evaluates correctly on its own. The error only
appeared when Saxon was left to lazily defer and batch many thousands of
these calls inside one large `xsl:variable`'s constructed content, at which
point it would occasionally force a deferred call against a stale context.
`xsl:try` reliably avoided it (by forcing eager evaluation) in isolation,
but the failure mode reappeared once nested inside the much larger compiled
schema's own template-dispatch machinery, so it wasn't a fix that could be
trusted in production.

Rebuilding the same relationship as two XPath maps — `xsl:map`/
`xsl:map-entry` construction with a pure `for ... return ... if ... then ...
else` XPath expression as each entry's value, no element nodes, no
`xsl:key` — sidesteps that evaluation path entirely and has run cleanly
through the full schema and benchmark repeatedly since. It's also arguably
the more idiomatic XPath 3.1 way to express a lookup table that was never
meant to be traversed as a document.

# Explicitly out of scope

- **Spatial/grid indexing.** The remaining cost is the one-time O(points ×
  lines) index build itself — every point is still bounding-box-tested
  against every candidate line at least once. A grid/bucket pre-filter
  (only comparing objects whose bounding boxes fall in the same or
  neighboring cell) would cut this further but is a separate, larger piece
  of work not undertaken here. **Update:** before pursuing this, see
  [geometry-parse-caching](./geometry-parse-caching) — a cheaper
  fix (memoizing the geometry parse itself, not the spatial comparison) cut
  `benchmark.sh` further from ~27s to 10s, and R.21's uncached endpoint scan
  (see next bullet) turned out to be a bigger contributor than this
  decision's own remaining points×lines cost.
- **R.21** (`geldig_eindpunt_kabel.sch`) calls `ma:parse-point` on the same
  object populations but checks point-to-point coincidence, not
  point-to-line touching — a structurally different relationship the
  connectivity index above doesn't model. It was deliberately left
  untouched to keep this change's blast radius limited to the 6 rules that
  actually share the rewritten relationship, rather than also modifying
  `ma:parse-point`/`ma:parse-line` themselves (which are called by all 41
  rules, not just these 6). **Update:** [geometry-parse-caching](./geometry-parse-caching)
  did modify those two functions (adding memoization only, signatures
  unchanged) and found R.21's O(kabels × moffen) reparsing — not the
  points×lines cost above — to be the dominant remaining cost at benchmark
  scale.

# Verification

- All 41 rules' `passing`/`failing` fixtures under
  [rule-test-fixtures](../testing/rule-test-fixtures) produced identical
  PASS/FAIL verdicts before and after (`scripts/validate_rules.sh` +
  `scripts/validate_rule_reports.sh`), including R.20/22/23/25/26/39.
- [coverage-checks](../testing/coverage-checks)
  (`check_rule_coverage.sh`, `check_rule_object_coverage.sh`): zero
  mismatches.
- `benchmark.sh` against `benchmark.xml`: **132s → ~27s** in this
  environment (~5x), consistent with removing the ×6 cross-rule duplication
  and the R.22/R.23 nested rescans.
