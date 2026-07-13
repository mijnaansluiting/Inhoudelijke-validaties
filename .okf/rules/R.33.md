---
type: Validation Rule
title: R.33 — Aanwezigheid bestand bijlage aanlegtechniek
description: Checks that every Aaanlegtechniek with SoortAanlegTechniek "GESTUURDE TECHNIEK" has a linked AbestandBijlage attachment of SoortBestand "Gestuurde boring".
resource: validation_schemas/patterns/v12/R.33.sch
tags: document
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A directional-drilling installation technique must be documented with a drilling report. This rule checks that, for any Aaanlegtechniek with SoortAanlegTechniek "GESTUURDE TECHNIEK", a related AbestandBijlage object exists with SoortBestand "Gestuurde boring".

# Details

- soort: Document
- validatieObjecten: Aaanlegtechniek
- Condition (objects related via Aaanlegtechniek.ID = AbestandBijlage.AssetObjectID; rule context is already restricted to `SoortAanlegTechniek = 'GESTUURDE TECHNIEK'`):
  - `check-bestand-bijlage-present`: at least one related AbestandBijlage must exist (message `object-not-present`, placeholder `Abestandbijlage`).
  - `bestandbijlage-must-be-gestuurde-boring`: the related AbestandBijlage's SoortBestand must equal "Gestuurde boring" (message `soort-bestand-not-correct`).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aanwezigheid_bestand_bijlage_aanlegtechniek.sch](../../validation_schemas/abstract_patterns/v12/document/aanwezigheid_bestand_bijlage_aanlegtechniek.sch)
