---
type: Validation Rule
title: R.20 — Topologie punt objecten Elec
description: Checks that Elec point objects are geometrically connected to the correct cable type and do not float unconnected.
resource: validation_schemas/patterns/v12/R.20.sch
tags: [topologie]
timestamp: 2026-07-08T00:00:00Z
---

# Overview
This rule verifies that point objects (Geometry of type `gml:Point`) in the electrical network are not left floating in space, but touch a cable line of the correct voltage class — medium-voltage points must connect to a medium-voltage cable, and low-voltage points must connect to a low-voltage cable.

# Details
- Rule category (`soort`): Topologie.
- Applies to (`validatieObjecten`): Eaardmof, LSmof, LSoverdrachtspunt, MSmof, MSoverdrachtspunt, OVLoverdrachtspunt.
- Condition: a point object may not float; it must be connected to the correct kabel:
  - `MSmof` and `MSoverdrachtspunt` must be connected to an `MSkabel` — the pattern parses the point's `Geometry` and asserts (`point-connected-to-kabel`) that it touches at least one `MSkabel/Geometry` line.
  - `Eaardmof`, `LSmof`, `LSoverdrachtspunt`, and `OVLoverdrachtspunt` must be connected to an `LSkabel` — the same assertion is checked against `LSkabel/Geometry` lines.

This point-to-cable topology check is complemented by [R.21](R.21.md), which validates the cable-side topology (valid end points of a kabel).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model.md) for the full scope×severity matrix.

The abstract pattern emits the `point-not-connected-to-any-line` message from the message catalog when a point object is not touching any line of the expected cable type; see [localization-messages](../config/localization-messages.md).

# Citations
[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [topologie_punt_objecten_elec.sch](../../validation_schemas/abstract_patterns/v12/topologie/topologie_punt_objecten_elec.sch)
