---
type: Validation Rule
title: R.12 — Verplichte kenmerken OVLoverdrachtspunt
description: Checks that every overhead-line transfer point (OVLoverdrachtspunt) has its required attributes populated.
resource: v12.1/rules/patterns/R.12.sch
tags: verplichte-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-10T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12.1/rules/abstract_patterns/verplichte_waarde/verplichte_kenmerken_ovloverdrachtspunt.sch"
    title: "verplichte_kenmerken_ovloverdrachtspunt.sch"
---

# Overview
This rule verifies that every OVLoverdrachtspunt (overhead-line transfer point) carries a full set of attributes describing its connection set, function, voltage level, connection method, switching configuration, and mast number.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): OVLoverdrachtspunt.
- Condition: every `OVLoverdrachtspunt` must have a value for `Aansluitset`, `Functie`, `Spanningsniveau`, `Aansluitwijze`, `Schakeling`, and `Mastnummer` (asserts `aansluitset-present`, `functie-present`, `spanningsniveau-present`, `aansluitwijze-present`, `schakeling-present`, `mastnummer-present`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern reports all missing attributes of an object in one failed assert, with the `attributes-not-present` message from the message catalog (`attribute-not-present` when only one is missing) and the names as `<attribute>` elements in the `missing-attributes` property; see [localization-messages](../config/localization-messages).
