---
type: Validation Rule
title: R.38 — Inmeetwijze aansluitnet toegestaande waarde
description: Checks that a LSkabel with Subnettype AANSLUITNET does not use Meetlint as its Inmeetwijze.
resource: validation_schemas/patterns/v12/R.38.sch
tags: inhoud-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/inhoud_waarde/inmeetwijze_aansluitnet_toegestaande_waarde.sch"
    title: "inmeetwijze_aansluitnet_toegestaande_waarde.sch"
---

# Overview

For an LSkabel whose Subnettype is "AANSLUITNET", this rule forbids the value "Meetlint" for Inmeetwijze. It exists purely to carve this one combination out of the general Inmeetwijze check in [R.37](./R.37), so that this specific AANSLUITNET/Meetlint case can be assigned its own severity level per scope, rather than always being treated at the same severity as any other disallowed Inmeetwijze value.

# Details

- soort: Inhoud waarde
- validatieObjecten: LSkabel
- Condition: it is not permitted for `Subnettype = 'AANSLUITNET'` and `Inmeetwijze = 'Meetlint'` to hold simultaneously.
- R.37's abstract pattern explicitly excludes this same AANSLUITNET/Meetlint combination from its own assertion, deferring the judgment to this rule instead. Per the scope model, this combination is typically flagged at a lower severity (e.g. warning) than the general R.37 violation (typically an error).

The abstract pattern also reads `ma:allowed-inmeetwijzen()` (the `ToegestaandeInmeetwijzen` list in `configuration/sys_config.xml`, i.e. GPS/Tachymeter) purely to include it in the violation message text; see [sys-config](../config/sys-config). On violation it emits the `inmeetwijze-not-allowed` message from the message catalog; see [localization-messages](../config/localization-messages).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
