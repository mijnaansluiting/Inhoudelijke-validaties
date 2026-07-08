---
type: Validation Rule
title: R.31 — Aanwezigheid bestand bijlage aardpen
description: Checks that every Eaardpen (earth pin) has a linked AbestandBijlage attachment of SoortBestand "Aardingsrapport".
resource: validation_schemas/patterns/v12/R.31.sch
tags: [document]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

An earth pin (Eaardpen) must be documented with a grounding report. This rule checks that an AbestandBijlage object linked to the Eaardpen exists and that its SoortBestand is "Aardingsrapport".

# Details

- soort: Document
- validatieObjecten: Eaardpen
- Condition (objects related via Eaardpen.ID = AbestandBijlage.AssetObjectID):
  - `check-bestand-bijlage-present`: at least one related AbestandBijlage must exist (message `object-not-present`, placeholder `Abestandbijlage`).
  - `check-correct-bestandsoort`: if present, its SoortBestand must equal "Aardingsrapport" (message `soort-bestand-not-correct`).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aanwezigheid_bestand_bijlage_aardpen.sch](../../validation_schemas/abstract_patterns/v12/document/aanwezigheid_bestand_bijlage_aardpen.sch)
