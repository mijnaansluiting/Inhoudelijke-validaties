---
type: Validation Rule
title: R.2 — Combinatie NLCS Status en Tekeningsoort
description: Checks that the NLCS Status values used by objects in the file are consistent with the Tekeningtype declared on the AprojectReferentie.
resource: validation_schemas/patterns/v12/R.2.sch
tags: [bestand]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

Depending on the Tekeningsoort (drawing type) of the project, only certain NLCS Status values are allowed to occur on the objects in the file. This rule prevents, for example, a "Bestaande Situatie" drawing from containing objects with a NIEUW or REVISIE status.

# Details

- soort: Bestand
- validatieObjecten: Document
- Condition: the allowed set of Status values is derived from `nlcs:AprojectReferentie/nlcs:Tekeningtype`:
  - BESTAANDE SITUATIE → only `BESTAAND`
  - DEELREVISIE, DEFINITIEF ONTWERP, EINDREVISIE → `BESTAAND`, `NIEUW`, `REVISIE`, `VERWIJDERD`
  - VOORONTWERP (and any other/unrecognized Tekeningtype) → no statuses allowed
  - The rule fails if any distinct Status value found among the file's objects falls outside the allowed set for the declared Tekeningtype.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [combinatie_nlcs_status_en_tekeningsoort.sch](../../validation_schemas/abstract_patterns/v12/bestand/combinatie_nlcs_status_en_tekeningsoort.sch)
