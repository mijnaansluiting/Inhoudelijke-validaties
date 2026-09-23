---
type: Validation Rule
title: R.40 — Volgnummer verplicht
description: Checks that AprojectReferentie has a Volgnummer value when Tekeningtype is DEELREVISIE or EINDREVISIE.
resource: validation_schemas/patterns/v12/R.40.sch
tags: bestand
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/bestand/volgnummer_verplicht.sch"
    title: "volgnummer_verplicht.sch"
---

# Overview

A partial or final revision drawing must be sequenced, so this rule requires the AprojectReferentie to carry a Volgnummer value whenever its Tekeningtype is "DEELREVISIE" or "EINDREVISIE".

# Details

- soort: Bestand
- validatieObjecten: AprojectReferentie
- Condition: for any `AprojectReferentie` where `Tekeningtype = 'DEELREVISIE'` or `Tekeningtype = 'EINDREVISIE'`, `Volgnummer` must exist and be non-empty (`ma:element-exists-and-not-empty`).

The abstract pattern emits the `attribute-not-present` message from the message catalog; see [localization-messages](../config/localization-messages).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
