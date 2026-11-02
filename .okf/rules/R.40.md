---
type: Validation Rule
title: R.40 — Volgnummer verplicht
description: Checks that AprojectReferentie has a Volgnummer value when Tekeningtype is DEELREVISIE or EINDREVISIE.
resource: v2026.1.0/rules/patterns/R.40.sch
tags: bestand
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v2026.1.0/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v2026.1.0/rules/abstract_patterns/bestand/volgnummer_verplicht.sch"
    title: "volgnummer_verplicht.sch"
---

# Overview

A partial or final revision drawing must be sequenced, so this rule requires the AprojectReferentie to carry a Volgnummer value whenever its Tekeningtype is "DEELREVISIE" or "EINDREVISIE".

# Details

- soort: Bestand
- validatieObjecten: AprojectReferentie
- Condition: for any `AprojectReferentie` where `Tekeningtype = 'DEELREVISIE'` or `Tekeningtype = 'EINDREVISIE'`, `Volgnummer` must exist and be non-empty (`ma:element-exists-and-not-empty`).

The abstract pattern emits the `attribute-not-present` message from the message catalog and reports Volgnummer as an `<attribute>` element in the `missing-attributes` property; see [localization-messages](../config/localization-messages).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
