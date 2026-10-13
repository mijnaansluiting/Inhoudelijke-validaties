---
type: Validation Rule
title: R.42 — Combinatie NLCS Status en Bedrijfstoestand
description: Checks that an NLCS object's Status is allowed for its Bedrijfstoestand (e.g. a VERWIJDERD object must have Bedrijfstoestand GEEN, a NIEUW object cannot be VERLATEN).
resource: validation_schemas/patterns/v12/R.42.sch
tags: bestand, status, bedrijfstoestand
generated:
  by: claude-code/claude-opus-5-5
  at: 2026-10-13T00:00:00Z
sources:
  - id: catalog
    resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - id: abstract-pattern
    resource: "../../validation_schemas/abstract_patterns/v12/bestand/combinatie_nlcs_status_en_bedrijfstoestand.sch"
    title: "combinatie_nlcs_status_en_bedrijfstoestand.sch"
  - id: fixtures
    resource: "../../test/rule_validation_data/v12/R.42"
    title: "R.42 passing/failing fixtures"
---

# Overview

The operational state of an asset (Bedrijfstoestand) constrains which NLCS
Status it can carry. A removed object (VERWIJDERD) no longer has an operational
state, so it must be GEEN; an abandoned object (VERLATEN) can only be something
that already existed or is being revised, never something newly designed.[^catalog]

# Details

- soort: Bestand
- validatieObjecten: AlleObjecten
- Allowed combinations (catalog definition, read per Status):

| Status | Allowed Bedrijfstoestand |
|---|---|
| BESTAAND | IN BEDRIJF, RESERVE, VERLATEN |
| NIEUW | IN BEDRIJF, RESERVE |
| REVISIE | IN BEDRIJF, RESERVE, VERLATEN |
| VERWIJDERD | GEEN |

The abstract pattern implements this inverted — per Bedrijfstoestand it builds
the list of allowed Statuses and asserts the object's Status is in it:[^abstract-pattern]

| Bedrijfstoestand | Allowed Status |
|---|---|
| VERLATEN | BESTAAND, REVISIE |
| RESERVE, IN BEDRIJF | BESTAAND, NIEUW, REVISIE |
| GEEN | VERWIJDERD |
| anything else (incl. missing/empty) | none |

The assert (`objects-have-allowed-status`) emits the
`invalid-status-for-bedrijfstoestand` message with placeholders
Bedrijfstoestand, allowed Statuses, and the offending Status; see
[localization-messages](../config/localization-messages).

Severity is `Fout` in every scope; see
[scope × severity matrix](../domain/scope-severity-model).

# Implementation notes

- An object that has a Status but no (or an unrecognised) Bedrijfstoestand
  gets an empty allowed list and therefore **fails**. Object types whose
  NLCS schema has no Bedrijfstoestand attribute would be flagged — worth
  checking before relying on this rule for non-cable objects.
- The rule context is
  `//nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie)]`, matching
  [R.41](./R.41), so AprojectReferentie is not evaluated. (An earlier version
  wrote `self::nlcs/AprojectReferentie`, which never matched.)
- Fixtures: passing `bestaand`, `nieuw`, `revisie`, `verwijderd`; failing
  `bestaand_geen`, `nieuw_geen`, `nieuw_verlaten`, `revisie_geen`,
  `verwijderd_in_bedrijf`, `verwijderd_reserve`, `verwijderd_verlaten`.[^fixtures]
  See [rule-test-fixtures](../testing/rule-test-fixtures).

[^catalog]: `doc/NLCSValidatieRegels.xml`, `validatieRegel nummer="R.42"`.
[^abstract-pattern]: `allowed_statuses` let in the abstract pattern.
[^fixtures]: `test/rule_validation_data/v12/R.42/{passing,failing}/`.
