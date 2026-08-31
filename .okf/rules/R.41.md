---
type: Validation Rule
title: R.41 — DatumTijdMutatie gevuld
description: Checks that DatumTijdMutatie is populated (and not present) exactly when an NLCS object's Status or Bewerking indicates a mutation, and that it is not a future date.
resource: validation_schemas/patterns/v12/R.41.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/datumtijdmutatie_gevuld.sch"
    title: "datumtijdmutatie_gevuld.sch"
---

# Overview

Objects that represent a change — anything not in the BESTAAND (existing/unchanged) status, or anything with a Bewerking (edit operation) value — must record when that mutation happened. This rule enforces that DatumTijdMutatie is present exactly when required, absent otherwise, and never set in the future.

# Details

- soort: Verplichte waarde
- validatieObjecten: AlleObjecten (every NLCS object under NLCSnetbeheer except AprojectReferentie)
- Condition: a mutation date is "expected" when `Status != 'BESTAAND'` or `Bewerking` is present and non-empty. If expected, `DatumTijdMutatie` must exist and be non-empty; if not expected, `DatumTijdMutatie` must be absent/empty. Additionally, whenever `DatumTijdMutatie` is present, it may not be later than the current date/time (`xs:dateTime(DatumTijdMutatie) gt current-dateTime()` must be false).

The abstract pattern emits the `attribute-not-present`, `attribute-present`, and `date-in-the-future` messages from the message catalog; see [localization-messages](../config/localization-messages).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
