---
type: Validation Rule
title: R.6 — Inmeetwijze en Nauwkeurigheid Lineaire Assets Elec
description: Checks that every linear Elec NLCS object has a value for both Inmeetwijze and Nauwkeurigheid.
resource: validation_schemas/patterns/v12/R.6.sch
tags: [verplichte-waarde]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

Linear Elec objects must record how they were surveyed (Inmeetwijze) and with what accuracy (Nauwkeurigheid), since this metadata is required to assess the reliability of the measured geometry.

# Details

- soort: Verplichte waarde
- validatieObjecten: Amantelbuis, Eaarddraad, LSkabel, MSkabel
- Condition: for each object of these types, `nlcs:Inmeetwijze` must be present and non-empty, and `nlcs:Nauwkeurigheid` must be present and non-empty.
- This rule only checks *presence* of a value for Inmeetwijze; which specific Inmeetwijze values are actually permitted is constrained separately by [R.37](/rules/R.37.md) and [R.38](/rules/R.38.md).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [inmeetwijze_en_nauwkeurigheid_assets_elec.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/inmeetwijze_en_nauwkeurigheid_assets_elec.sch)
