---
type: Validation Rule
title: R.3 — Geometrie binnen Projectvlak
description: Checks that every point, line, and area geometry of every NLCS object in the file interacts with the project area of the AprojectReferentie.
resource: v2026.1.0/rules/patterns/R.3.sch
tags: geometrie
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v2026.1.0/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v2026.1.0/rules/abstract_patterns/geometrie/geometrie_binnen_projectvlak.sch"
    title: "geometrie_binnen_projectvlak.sch"
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

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
