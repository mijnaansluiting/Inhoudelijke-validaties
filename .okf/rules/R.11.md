---
type: Validation Rule
title: R.11 — Verplichte kenmerken LSoverdrachtspunt
description: Checks that every low-voltage transfer point (LSoverdrachtspunt) has its required attributes populated.
resource: validation_schemas/patterns/v12/R.11.sch
tags: verplichte-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview
This rule verifies that every LSoverdrachtspunt (low-voltage transfer/connection point) has the attributes needed to describe its orientation, function, phasing, and earthing system, so downstream consumers can rely on these being present.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): LSoverdrachtspunt.
- Condition: every `LSoverdrachtspunt` must have a value for `EigenRichting`, `Functie`, `FaseAanduiding`, and `Aardingsysteem` (asserts `eigen-richting-present`, `functie-present`, `fase-aanduiding-present`, `aardingsysteem-present`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog for each missing attribute; see [localization-messages](../config/localization-messages).

# Citations
[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verplichte_kenmerken_lsoverdrachtspunt.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_lsoverdrachtspunt.sch)
