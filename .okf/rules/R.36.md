---
type: Validation Rule
title: R.36 — Afstand mantelbuis tot inhoud
description: Checks that every content asset related to an Amantelbuis (duct) lies within a configurable maximum distance of that duct's line geometry.
resource: validation_schemas/patterns/v12/R.36.sch
tags: [geometrie]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

The assets running through a duct (mantelbuis) should physically lie along that duct, not stray far away from it. This rule checks that every content object linked to an Amantelbuis via AmantelbuisInhoud has geometry within a configurable maximum distance of the duct's own line geometry. The check assumes a duct does not cross itself.

# Details

- soort: Geometrie
- validatieObjecten: Amantelbuis
- Condition:
  - Content objects are gathered via `AmantelbuisInhoud[MantelbuisID = duct ID]/InhoudID`, resolved to their NLCS objects.
  - Both the duct and each content object's `Geometry` are parsed into lines (`ma:parse-line`).
  - `inhoud-in-range-of-mantelbuis`: every content object's line must be within `ma:mantelbuis-inhoud-asset-max-distance()` of the duct's line (`ma:line-within-range-of-line`); any that are not are reported together (message `inhoud-assets-not-in-range-of-mantelbuis`, with the offending count and the max distance as placeholders).

The maximum distance is read from `configuration/sys_config.xml`'s `MantelbuisInhoudMaxAfstand` (currently `1`, in meters) via `ma:mantelbuis-inhoud-asset-max-distance()` — this is the "configurable" threshold called for in the rule's definition. See [sys_config reference](/config/sys-config.md).

The distance/line-buffer calculation behind this rule has been the subject of recent bugfixes (handling sequential coordinates at the same position, and rounding the computed distance to millimeters before comparing against the threshold to avoid floating-point false positives). See [distance precision rounding decision](/decisions/distance-precision-rounding.md) for the rationale behind those choices.

This rule is closely related to [R.27](/rules/R.27.md) and [R.30](/rules/R.30.md), which impose further consistency constraints on the same mantelbuis/inhoud relationship.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [afstand_mantelbuis_tot_inhoud.sch](../../validation_schemas/abstract_patterns/v12/geometrie/afstand_mantelbuis_tot_inhoud.sch)
