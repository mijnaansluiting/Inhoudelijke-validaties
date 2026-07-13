---
type: Validation Rule
title: R.3 — Geometrie binnen Projectvlak
description: Checks that every point, line, and area geometry of every NLCS object in the file interacts with the project area of the AprojectReferentie.
resource: validation_schemas/patterns/v12/R.3.sch
tags: geometrie
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

Every NLCS object's geometry must spatially interact with the project area (the gml:Surface geometry) declared on the AprojectReferentie. This prevents objects from being submitted that lie entirely outside the project's own geographic scope.

# Details

- soort: Geometrie
- validatieObjecten: Aaanlegtechniek, AbeschermingVlak, Akunstwerk, Amantelbuis, Eaarddraad, Eaardpen, LSkabel, LSmof, LSoverdrachtspunt, MSkabel, MSmof, MSoverdrachtspunt, MSstation, OVLoverdrachtspunt
- Condition: depending on the geometry type of the object, the check differs:
  - Point objects (MSmof, MSoverdrachtspunt, LSmof, LSoverdrachtspunt, OVLoverdrachtspunt, Eaardpen): the object's gml:Point must interact with the project area (`ma:point-interacts-with-area`).
  - Line objects (MSkabel, Amantelbuis, Akunstwerk, Eaarddraad, Aaanlegtechniek, LSkabel): the object's gml:Curve must interact with the project area (`ma:line-interacts-with-area`).
  - Area objects (MSstation, AbeschermingVlak): the object's gml:Surface must interact with the project area (`ma:area-interacts-with-area`).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [geometrie_binnen_projectvlak.sch](../../validation_schemas/abstract_patterns/v12/geometrie/geometrie_binnen_projectvlak.sch)
