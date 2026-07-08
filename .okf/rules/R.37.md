---
type: Validation Rule
title: R.37 — Inmeetwijze toegestaande waarde
description: Checks that Inmeetwijze on linear electrical assets is either GPS or Tachymeter, except for a separately-validated LSkabel AANSLUITNET/Meetlint combination.
resource: validation_schemas/patterns/v12/R.37.sch
tags: [inhoud-waarde]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

This rule checks that the value of Inmeetwijze is either "GPS" or "Tachymeter" for linear electrical assets. The one exception is an LSkabel with Subnettype "AANSLUITNET", for which Inmeetwijze "Meetlint" is also tolerated here — that specific combination is excluded from this rule's assertion so it can instead be validated separately at its own severity level by [R.38](/rules/R.38.md).

# Details

- soort: Inhoud waarde
- validatieObjecten: LSkabel, MSkabel, Amantelbuis, Eaarddraad
- Condition: `Inmeetwijze` must be a member of the configured allowed values, unless the object is an LSkabel with `Subnettype = 'AANSLUITNET'` and `Inmeetwijze = 'Meetlint'` (the `aansluitnet_meetlint_exception`), in which case the assertion is skipped so R.38 can judge it independently.
- This rule only checks the *value* of Inmeetwijze; whether a value is present at all is checked separately by [R.6](/rules/R.6.md).

The abstract pattern reads its allowed-values list via `ma:allowed-inmeetwijzen()`, which returns `configuration/sys_config.xml`'s `ToegestaandeInmeetwijzen` entries (GPS, Tachymeter); see [sys-config](/config/sys-config.md). On violation it emits the `inmeetwijze-not-allowed` message from the message catalog; see [localization-messages](/config/localization-messages.md).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [inmeetwijze_toegestaande_waarde.sch](../../validation_schemas/abstract_patterns/v12/inhoud_waarde/inmeetwijze_toegestaande_waarde.sch)
