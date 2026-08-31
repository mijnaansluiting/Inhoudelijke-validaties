---
type: Validation Rule
title: R.34 — Reden niet-verwijdering ingevuld
description: Checks that an abandoned cable (Status REVISIE, Bedrijfstoestand VERLATEN) has a value for RedenNietVerwijdering explaining why it was not removed.
resource: validation_schemas/patterns/v12/R.34.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/reden_niet_verwijdering_ingevuld.sch"
    title: "reden_niet_verwijdering_ingevuld.sch"
---

# Overview

When a cable is abandoned in place rather than physically removed, the reason for not removing it must be recorded. This rule checks that any LSkabel/MSkabel with Status=REVISIE and Bedrijfstoestand=VERLATEN has a non-empty RedenNietVerwijdering value.

# Details

- soort: Verplichte waarde
- validatieObjecten: LSkabel, MSkabel
- Condition:
  - `should_be_tested`: Status = 'REVISIE' and Bedrijfstoestand = 'VERLATEN'.
  - `reden-niet-verwijdering-present`: if `should_be_tested`, RedenNietVerwijdering must exist and be non-empty (message `attribute-not-present`, placeholder `RedenNietVerwijdering`); otherwise the assertion passes vacuously.

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
