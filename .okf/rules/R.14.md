---
type: Validation Rule
title: R.14 — Verplichte kenmerken Stations en Kasten
description: Checks that every station or low-voltage cabinet has its Nummer and Functie attributes populated.
resource: v12/rules/patterns/R.14.sch
tags: verplichte-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12/rules/abstract_patterns/verplichte_waarde/verplichte_kenmerken_stations_en_kasten.sch"
    title: "verplichte_kenmerken_stations_en_kasten.sch"
---

# Overview
This rule verifies that every station or cabinet object records both an identifying number and its function, so these installations can be uniquely referenced and their role in the network understood.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): HSstation, LSkast, MSstation.
- Condition: every `LSkast`, `MSstation`, and `HSstation` must have a value for `Nummer` and `Functie` (asserts `object-has-number`, `object-has-functie`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern reports all missing attributes of an object in one failed assert, with the `attributes-not-present` message from the message catalog (`attribute-not-present` when only one is missing) and the names as `<attribute>` elements in the `missing-attributes` property; see [localization-messages](../config/localization-messages).
