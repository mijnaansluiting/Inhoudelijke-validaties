---
type: Validation Rule
title: R.6 — Inmeetwijze en Nauwkeurigheid Lineaire Assets Elec
description: Checks that every linear Elec NLCS object has a value for both Inmeetwijze and Nauwkeurigheid.
resource: validation_schemas/patterns/v12/R.6.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/inmeetwijze_en_nauwkeurigheid_assets_elec.sch"
    title: "inmeetwijze_en_nauwkeurigheid_assets_elec.sch"
---

# Overview

Linear Elec objects must record how they were surveyed (Inmeetwijze) and with what accuracy (Nauwkeurigheid), since this metadata is required to assess the reliability of the measured geometry.

# Details

- soort: Verplichte waarde
- validatieObjecten: Amantelbuis, Eaarddraad, LSkabel, MSkabel
- Condition: for each object of these types, `nlcs:Inmeetwijze` must be present and non-empty, and `nlcs:Nauwkeurigheid` must be present and non-empty.
- This rule only checks *presence* of a value for Inmeetwijze; which specific Inmeetwijze values are actually permitted is constrained separately by [R.37](./R.37) and [R.38](./R.38).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
