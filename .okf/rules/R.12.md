---
type: Validation Rule
title: R.12 — Verplichte kenmerken OVLoverdrachtspunt
description: Checks that every overhead-line transfer point (OVLoverdrachtspunt) has its required attributes populated.
resource: validation_schemas/patterns/v12/R.12.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_ovloverdrachtspunt.sch"
    title: "verplichte_kenmerken_ovloverdrachtspunt.sch"
---

# Overview
This rule verifies that every OVLoverdrachtspunt (overhead-line transfer point) carries a full set of attributes describing its connection set, function, voltage level, connection method, switching configuration, and mast number.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): OVLoverdrachtspunt.
- Condition: every `OVLoverdrachtspunt` must have a value for `Aansluitset`, `Functie`, `Spanningsniveau`, `Aansluitwijze`, `Schakeling`, and `Mastnummer` (asserts `aansluitset-present`, `functie-present`, `spanningsniveau-present`, `aansluitwijze-present`, `schakeling-present`, `mastnummer-present`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog for each missing attribute; see [localization-messages](../config/localization-messages).
