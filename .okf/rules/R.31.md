---
type: Validation Rule
title: R.31 — Aanwezigheid bestand bijlage aardpen
description: Checks that every Eaardpen (earth pin) has a linked AbestandBijlage attachment of SoortBestand "Aardingsrapport".
resource: v12/rules/patterns/R.31.sch
tags: document
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12/rules/abstract_patterns/document/aanwezigheid_bestand_bijlage_aardpen.sch"
    title: "aanwezigheid_bestand_bijlage_aardpen.sch"
---

# Overview

An earth pin (Eaardpen) must be documented with a grounding report. This rule checks that an AbestandBijlage object linked to the Eaardpen exists and that its SoortBestand is "Aardingsrapport".

# Details

- soort: Document
- validatieObjecten: Eaardpen
- Condition (objects related via Eaardpen.ID = AbestandBijlage.AssetObjectID):
  - `check-bestand-bijlage-present`: at least one related AbestandBijlage must exist (message `object-not-present`, placeholder `Abestandbijlage`).
  - `check-correct-bestandsoort`: if present, its SoortBestand must equal "Aardingsrapport" (message `soort-bestand-not-correct`).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
