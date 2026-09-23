---
type: Validation Rule
title: R.10 — Verplichte kenmerken moffen
description: Checks that every cable joint (mof) has its baseline required attributes populated, with extra attributes required depending on voltage level.
resource: validation_schemas/patterns/v12/R.10.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_moffen.sch"
    title: "verplichte_kenmerken_moffen.sch"
---

# Overview
This rule verifies that every mof (cable joint) has a minimal set of attributes filled in, so that its function and connection number are always traceable. Depending on the mof's voltage class, additional attributes are required: low-voltage joints must record whether they sit above ground, while medium- and high-voltage joints must record the installing technician and cross-bonding status.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): HSmof, LSmof, MSmof.
- Condition:
  - Every mof (HSmof, LSmof, MSmof) must have a value for `Functie` and `Verbindingnummer`.
  - Additionally, every `LSmof` must have a value for `Bovengronds`.
  - Additionally, every `MSmof` and `HSmof` must have a value for `NaamMonteur` and `CrossBondingAanwezig`.
- The abstract pattern implements this with two separate rule contexts: one for `MSmof | HSmof` (Functie, Verbindingnummer, NaamMonteur, CrossBondingAanwezig) and one for `LSmof` (Functie, Verbindingnummer, Bovengronds).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog for each missing attribute; see [localization-messages](../config/localization-messages).
