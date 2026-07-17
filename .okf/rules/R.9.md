---
type: Validation Rule
title: R.9 — Aanlegdatum gevuld
description: Checks that the DatumAanleg (installation date) is populated and does not lie in the future for a broad set of electrical network assets.
resource: validation_schemas/patterns/v12/R.9.sch
tags: verplichte-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview
This rule verifies that every applicable electrical asset carries a populated `DatumAanleg` (installation/laying date) attribute, and that this date is not set later than today. Enforcing this keeps the network's construction-date history complete and internally consistent.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): Eaarddraad, Eaardpen, LSkabel, LSmof, LSoverdrachtspunt, MSstation, MSkabel, MSmof, MSoverdrachtspunt, OVLoverdrachtspunt.
- Condition: `DatumAanleg` must exist and be non-empty (assert `date-exists`); if present, `DatumAanleg` must be less than or equal to the current date (assert `date-not-in-future`) — i.e. it may not be a future date.

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` and `date-in-the-future` messages from the message catalog; see [localization-messages](../config/localization-messages).

# Citations
[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aanlegdatum_gevuld.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/aanlegdatum_gevuld.sch)
