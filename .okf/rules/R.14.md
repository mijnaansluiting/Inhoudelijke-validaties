---
type: Validation Rule
title: R.14 — Verplichte kenmerken Stations en Kasten
description: Checks that every station or low-voltage cabinet has its Nummer and Functie attributes populated.
resource: validation_schemas/patterns/v12/R.14.sch
tags: verplichte-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview
This rule verifies that every station or cabinet object records both an identifying number and its function, so these installations can be uniquely referenced and their role in the network understood.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): HSstation, LSkast, MSstation.
- Condition: every `LSkast`, `MSstation`, and `HSstation` must have a value for `Nummer` and `Functie` (asserts `object-has-number`, `object-has-functie`).

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog for each missing attribute; see [localization-messages](../config/localization-messages).

# Citations
[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verplichte_kenmerken_stations_en_kasten.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_stations_en_kasten.sch)
