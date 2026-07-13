---
type: Validation Rule
title: R.21 — Geldig eindpunt Kabel
description: Checks that every cable has a valid connected object at both its start and end point.
resource: validation_schemas/patterns/v12/R.21.sch
tags: topologie
timestamp: 2026-07-10T00:00:00Z
published: true
editor: markdown
date: 2026-07-10T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

Every cable must be properly connected at both ends: a dangling start or end point indicates a topology error in the network. The rule checks the start and end point of the cable's geometry against the geometries of the object types that are valid endpoints for that cable type.

# Details

- Rule category (`soort`): Topologie
- Applies to (`validatieObjecten`): Eaarddraad, LSkabel, MSkabel
- Valid endpoints per cable type:

  | Object type | Valid endpoint types |
  |---|---|
  | Eaarddraad | LSmof, MSmof, Eaardmof, Eaardpen, MSstation, LSkast |
  | MSkabel | MSmof, MSoverdrachtspunt, MSstation |
  | LSkabel | LSmof, LSoverdrachtspunt, OVLoverdrachtspunt, MSstation, LSkast |

- A cable's start point is checked for point-connection (or, for MSstation/LSkast, area-touching) against the geometries of the applicable endpoint types; the same check is done independently for the end point.
- The check is skipped entirely for cables with Bedrijfstoestand "VERLATEN".
- Each endpoint check is only performed when that endpoint lies within the project area (`AprojectReferentie`); endpoints outside the project area are not evaluated.
- Failing endpoints are reported with their geometry (via `ma:create-gml-point`) so the offending point can be located on the map.

See [R.20](/rules/R.20.md) for the related point-topology rule.

This rule's endpoint scan (every cable against every candidate endpoint
object) was the dominant remaining cost in the geometry-parsing pipeline —
see [geometry-parse-caching](/decisions/geometry-parse-caching.md) for why
`ma:parse-point`/`ma:parse-area` are now memoized per geometry node.

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [geldig_eindpunt_kabel.sch](../../validation_schemas/abstract_patterns/v12/topologie/geldig_eindpunt_kabel.sch)
