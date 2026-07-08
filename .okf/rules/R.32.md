---
type: Validation Rule
title: R.32 — Aanwezigheid bestand bijlage kunstwerk
description: Checks that every zinker-type Akunstwerk has a linked AbestandBijlage attachment of SoortBestand "Zinkertekening".
resource: validation_schemas/patterns/v12/R.32.sch
tags: [document]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

A subaqueous crossing structure (a "zinker") must be documented with a drawing. This rule checks that, for any Akunstwerk whose SoortKunstwerk starts with "ZINKER" (e.g. ZINKER, ZINKER_BOOG, ZINKER_SLEEP, ZINKER_OMGEKEERD, ZINKER_SPUIT), a related AbestandBijlage object exists with SoortBestand "Zinkertekening".

# Details

- soort: Document
- validatieObjecten: Akunstwerk
- Condition (objects related via Akunstwerk.ID = AbestandBijlage.AssetObjectID):
  - Only applies when `is_zinker` (SoortKunstwerk starts with "ZINKER"); non-zinker kunstwerken are not constrained.
  - `check-bestand-bijlage-present`: for zinker kunstwerken, at least one related AbestandBijlage must exist (message `object-not-present`, placeholder `Abestandbijlage`).
  - `soort_bestand_correct`: for zinker kunstwerken, the related AbestandBijlage's SoortBestand must equal "Zinkertekening" (message `soort-bestand-not-correct`).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aanwezigheid_bestand_bijlage_kunstwerk.sch](../../validation_schemas/abstract_patterns/v12/document/aanwezigheid_bestand_bijlage_kunstwerk.sch)
