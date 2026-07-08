---
type: Validation Rule
title: R.40 — Volgnummer verplicht
description: Checks that AprojectReferentie has a Volgnummer value when Tekeningtype is DEELREVISIE or EINDREVISIE.
resource: validation_schemas/patterns/v12/R.40.sch
tags: [bestand]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

A partial or final revision drawing must be sequenced, so this rule requires the AprojectReferentie to carry a Volgnummer value whenever its Tekeningtype is "DEELREVISIE" or "EINDREVISIE".

# Details

- soort: Bestand
- validatieObjecten: AprojectReferentie
- Condition: for any `AprojectReferentie` where `Tekeningtype = 'DEELREVISIE'` or `Tekeningtype = 'EINDREVISIE'`, `Volgnummer` must exist and be non-empty (`ma:element-exists-and-not-empty`).

The abstract pattern emits the `attribute-not-present` message from the message catalog; see [localization-messages](/config/localization-messages.md).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [volgnummer_verplicht.sch](../../validation_schemas/abstract_patterns/v12/bestand/volgnummer_verplicht.sch)
