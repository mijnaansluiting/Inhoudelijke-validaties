---
type: Architecture Component
title: XSL function libraries
description: The versioned custom ma:-namespace XSLT function libraries every rule's logic is built from.
resource: v12/xsl_functions/
tags: architecture, xslt
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v12/xsl_functions/"
    title: "v12/xsl_functions/"
---

# Overview

`<version>/xsl_functions/` holds XSLT 3.0 function libraries in a custom
`ma:` (mijnaansluiting) namespace, used by every abstract pattern. They are
version-managed like patterns (see
[multiversion-model](../decisions/multiversion-model)): currently only
`v12/xsl_functions/` exists, and `v12.1` inherits it unchanged.
A version's [`<version>/rules/main.sch`](./schematron-layering) includes its
own libraries as `../../xsl_functions/…` or an older version's as
`../../../<older version>/xsl_functions/…` (both resolved from the compiled
output in `<version>/rules/transpiled_phases/`).
The libraries load their data relative to their own folder:
`document('../../configuration/…')`, `document('../../localization/messages.xml')`
and `document('../../' || $active_version || '/doc/NLCSValidatieRegels.xml')`,
so an inherited library still reads the catalog of the version being run;
the release `dist/` mirrors this layout so the same paths resolve there.
`version_functions.xsl` (version selection from `configuration/versions.xml`)
lives in the same folder but is not included by any `main.sch`.

| File | Purpose |
|---|---|
| `geometry_functions.xsl` | Parses and analyzes GML geometry (`gml:Point`/`gml:Curve`/`gml:Surface`): intersection/containment checks, segment length and angle calculations, distance calculations. The largest library — backs geometric rules like [R.3](../rules/R.3), [R.4](../rules/R.4), and [R.36](../rules/R.36). |
| `config_functions.xsl` | Reads the active version's block of [`configuration/sys_config.xml`](../config/sys-config) — decimal precision, allowed-value lists, thresholds, exceptions — e.g. `ma:allowed-inmeetwijzen()` for [R.37](../rules/R.37), `ma:mantelbuis-inhoud-asset-max-distance()` for [R.36](../rules/R.36), `ma:map-mof-functie()` for [R.26](../rules/R.26), and the GisId/AssetId exception lookups for [R.5](../rules/R.5). |
| `localization_functions.xsl` | Looks up a message by id and language in [`localization/messages.xml`](../config/localization-messages) (per the `Language` setting in `configuration/user_config.xml`), substituting `{n}` placeholders with rule-specific values before attaching the text to an `assert`. |
| `rule_scope_functions.xsl` | The scope/severity engine — reads the `<scopes>` section of the active version's catalog, `<version>/doc/NLCSValidatieRegels.xml`, to compute `ma:scope-name`, `ma:rule-severity-within-scope`, and `ma:rule-within-scope-for-object`, matching an object's Tekeningtype/Status/Bedrijfstoestand to one of the 8 scopes. See [scope-severity-model](../domain/scope-severity-model). |
| `helper_functions.xsl` | Misc utilities shared across abstract patterns (e.g. object-existence and attribute-presence helpers used by many "verplichte kenmerken" rules), plus `ma:parse-point`/`ma:parse-line`/`ma:parse-area` — GML coordinate-string parsing, memoized per geometry node via lazily-built XPath maps since [geometry-parse-caching](../decisions/geometry-parse-caching), used directly by [R.3](../rules/R.3), [R.4](../rules/R.4), [R.21](../rules/R.21), [R.36](../rules/R.36) and transitively by [R.20](../rules/R.20)/[R.22](../rules/R.22)/[R.23](../rules/R.23)/[R.25](../rules/R.25)/[R.26](../rules/R.26)/[R.39](../rules/R.39) via `connectivity_functions.xsl`. Parsed coordinates are `array(xs:double)` values (a point is `array{x, y[, z]}`), not XML element nodes — see [coord-representation-array-vs-node](../decisions/coord-representation-array-vs-node) for the ~34% performance benchmark behind that choice. |
| `connectivity_functions.xsl` | A shared mof/overdrachtspunt ↔ kabel/eaarddraad touch index (`ma:touching-kabels`, `ma:touching-moffen`, `ma:touching-kabels-via-moffen`), computed once per run and reused by [R.20](../rules/R.20), [R.22](../rules/R.22), [R.23](../rules/R.23), [R.25](../rules/R.25), [R.26](../rules/R.26), and [R.39](../rules/R.39) instead of each doing its own brute-force scan. See [connectivity-index-and-geometry-caching](../decisions/connectivity-index-and-geometry-caching) for why. |
