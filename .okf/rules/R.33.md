---
type: Validation Rule
title: R.33 — Aanwezigheid bestand bijlage aanlegtechniek
description: Checks that every Aaanlegtechniek with SoortAanlegTechniek "GESTUURDE TECHNIEK" has a linked AbestandBijlage attachment of SoortBestand "Gestuurde boring".
resource: v2026.1.0/rules/patterns/R.33.sch
tags: document
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v2026.1.0/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v2026.1.0/rules/abstract_patterns/document/aanwezigheid_bestand_bijlage_aanlegtechniek.sch"
    title: "aanwezigheid_bestand_bijlage_aanlegtechniek.sch"
---

# Overview

A directional-drilling installation technique must be documented with a drilling report. This rule checks that, for any Aaanlegtechniek with SoortAanlegTechniek "GESTUURDE TECHNIEK", a related AbestandBijlage object exists with SoortBestand "Gestuurde boring".

# Details

- soort: Document
- validatieObjecten: Aaanlegtechniek
- Condition (objects related via Aaanlegtechniek.ID = AbestandBijlage.AssetObjectID; rule context is already restricted to `SoortAanlegTechniek = 'GESTUURDE TECHNIEK'`):
  - `check-bestand-bijlage-present`: at least one related AbestandBijlage must exist (message `object-not-present`, placeholder `Abestandbijlage`).
  - `bestandbijlage-must-be-gestuurde-boring`: the related AbestandBijlage's SoortBestand must equal "Gestuurde boring" (message `soort-bestand-not-correct`).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
