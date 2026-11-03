---
type: Validation Rule
title: R.13 — Verplichte kenmerken MSoverdrachtspunt
description: Checks that every medium-voltage transfer point (MSoverdrachtspunt) has its Identificatie (EAN code) attribute populated.
resource: v2026.1.0/rules/patterns/R.13.sch
tags: verplichte-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v2026.1.0/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v2026.1.0/rules/abstract_patterns/verplichte_waarde/verplichte_kenmerken_msoverdrachtspunt.sch"
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
