---
type: Validation Rule
title: R.13 — Verplichte kenmerken MSoverdrachtspunt
description: Checks that every medium-voltage transfer point (MSoverdrachtspunt) has its Identificatie (EAN code) attribute populated.
resource: validation_schemas/patterns/v12/R.13.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_msoverdrachtspunt.sch"
    title: "verplichte_kenmerken_msoverdrachtspunt.sch"
---

# Overview
This rule verifies that every MSoverdrachtspunt (medium-voltage transfer point) has an `Identificatie` value, which holds the EAN code that uniquely identifies the connection point in downstream systems.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): MSoverdrachtspunt.
- Condition: every `MSoverdrachtspunt` must have a value for `Identificatie` (EAN code), enforced by assert `v12-msoverdrachtspunt-has-identification`.

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog when `Identificatie` is missing; see [localization-messages](../config/localization-messages).
