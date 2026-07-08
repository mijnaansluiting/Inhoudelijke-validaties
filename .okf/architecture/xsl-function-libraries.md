---
type: Architecture Component
title: Shared XSL function libraries
description: The five custom ma:-namespace XSLT function libraries every rule's logic is built from.
resource: validation_schemas/xsl_functions/
tags: [architecture, xslt]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

`validation_schemas/xsl_functions/` holds shared XSLT 3.0 function libraries
in a custom `ma:` (mijnaansluiting) namespace, included once into
[`base/v12.sch`](/architecture/schematron-layering.md) and used by every
abstract pattern:

| File | Purpose |
|---|---|
| `geometry_functions.xsl` | Parses and analyzes GML geometry (`gml:Point`/`gml:Curve`/`gml:Surface`): intersection/containment checks, segment length and angle calculations, distance calculations. The largest library — backs geometric rules like [R.3](/rules/R.3.md), [R.4](/rules/R.4.md), and [R.36](/rules/R.36.md). |
| `config_functions.xsl` | Reads [`configuration/sys_config.xml`](/config/sys-config.md) — decimal precision, allowed-value lists, thresholds, exceptions — e.g. `ma:allowed-inmeetwijzen()` for [R.37](/rules/R.37.md), `ma:mantelbuis-inhoud-asset-max-distance()` for [R.36](/rules/R.36.md), `ma:map-mof-functie()` for [R.26](/rules/R.26.md), and the GisId/AssetId exception lookups for [R.5](/rules/R.5.md). |
| `localization_functions.xsl` | Looks up a message by id and language in [`localization/messages.xml`](/config/localization-messages.md) (per the `Language` setting in `configuration/user_config.xml`), substituting `{n}` placeholders with rule-specific values before attaching the text to an `assert`. |
| `rule_scope_functions.xsl` | The scope/severity engine — reads the `<scopes>` section of `doc/NLCSValidatieRegels.xml` to compute `ma:scope-name`, `ma:rule-severity-within-scope`, and `ma:rule-within-scope-for-object`, matching an object's Tekeningtype/Status/Bedrijfstoestand to one of the 8 scopes. See [scope-severity-model](/domain/scope-severity-model.md). |
| `helper_functions.xsl` | Misc utilities shared across abstract patterns (e.g. object-existence and attribute-presence helpers used by many "verplichte kenmerken" rules). |

# Citations

[1] [validation_schemas/xsl_functions/](../../validation_schemas/xsl_functions/)
