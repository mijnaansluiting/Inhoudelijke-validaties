---
type: Validation Rule
title: R.11 — Verplichte kenmerken LSoverdrachtspunt
description: Checks that every low-voltage transfer point (LSoverdrachtspunt) has its required attributes populated.
resource: v12.1/rules/patterns/R.11.sch
tags: verplichte-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-10T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12.1/rules/abstract_patterns/verplichte_waarde/verplichte_kenmerken_lsoverdrachtspunt.sch"
    title: "verplichte_kenmerken_lsoverdrachtspunt.sch"
---

# Overview
This rule verifies that every LSoverdrachtspunt (low-voltage transfer/connection point) has the attributes needed to describe its orientation, function, phasing, and earthing system, so downstream consumers can rely on these being present.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): LSoverdrachtspunt.
- Condition: every `LSoverdrachtspunt` must have a value for `EigenRichting`, `Functie`, `FaseAanduiding`, and `Aardingsysteem` (asserts `eigen-richting-present`, `functie-present`, `fase-aanduiding-present`, `aardingsysteem-present`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern reports all missing attributes of an object in one failed assert, with the `attributes-not-present` message from the message catalog (`attribute-not-present` when only one is missing) and the names as `<attribute>` elements in the `missing-attributes` property; see [localization-messages](../config/localization-messages).
