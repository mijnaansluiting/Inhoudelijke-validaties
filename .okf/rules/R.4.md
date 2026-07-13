---
type: Validation Rule
title: R.4 — Lijn Geometrie (afstand en hoek van inmeetpunten)
description: Checks that line and area-outline geometries respect the minimum/maximum distance between survey points and do not contain sharp kinks between segments.
resource: validation_schemas/patterns/v12/R.4_A.sch
tags: geometrie
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A line (gml:Curve), or the outline of an area (gml:Surface), must meet survey-measurement (inmeet) requirements: consecutive survey points must be neither too close together nor too far apart, and the line must not contain unrealistically sharp kinks between consecutive segments.

# Details

- soort: Geometrie
- validatieObjecten: Aaanlegtechniek, Amantelbuis, Eaarddraad, LSkabel, MSkabel (segment-length check also applies to MSstation, whose area outline is treated as a line of segments)
- This rule is implemented as two separate Schematron sub-checks:
  - **R.4-A** (segment length): each segment between consecutive (inmeet)points of a line or area outline must be at least 10 cm and at most 50 m long. Implemented via `ma:line-segments-not-meeting-length-demands`.
  - **R.4-B** (segment angle): the angle between consecutive segments of a line must not exceed 45 degrees (no sharp kinks). Applies only to line objects (Aaanlegtechniek, Eaarddraad, LSkabel, MSkabel), not to MSstation areas. Implemented via `ma:line-segments-not-meeting-angle-demands`.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

Line-buffer and distance calculations underlying this rule's segment-length and angle checks were the subject of recent precision/rounding fixes; see [distance & precision rounding](/decisions/distance-precision-rounding.md) for details.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [lijn_geometrie-afstand_van_inmeetpunten.sch (R.4-A)](../../validation_schemas/abstract_patterns/v12/geometrie/lijn_geometrie-afstand_van_inmeetpunten.sch), [lijn_geometrie-hoek_van_segmenten.sch (R.4-B)](../../validation_schemas/abstract_patterns/v12/geometrie/lijn_geometrie-hoek_van_segmenten.sch)
