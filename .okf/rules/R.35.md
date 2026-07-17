---
type: Validation Rule
title: R.35 — Aanwezigheid maaiveldhoogte
description: Checks that a revision drawing file (Tekeningtype DEELREVISIE or EINDREVISIE) contains at least one Amaaiveldhoogte (ground level) object.
resource: validation_schemas/patterns/v12/R.35.sch
tags: bestand
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A revision drawing must include at least one ground-level measurement. This rule checks, at the level of the whole NLCS++ file, that a revision-type drawing (Tekeningtype DEELREVISIE or EINDREVISIE) contains one or more Amaaiveldhoogte objects.

# Details

- soort: Bestand
- validatieObjecten: Document (evaluated at NLCSnetbeheer/file level, not per individual object)
- Condition:
  - `is_revisie`: AprojectReferentie/Tekeningtype is one of DEELREVISIE or EINDREVISIE.
  - `revisie-has-maaiveldhoogte`: if `is_revisie`, the count of Amaaiveldhoogte children must be greater than 0 (message `revisie-no-maaiveldhoogte-present`); otherwise the assertion passes vacuously.
  - Note this assertion's `properties` list is `rule-number severity` only (no `scope`/`object-type`/`object-id`), consistent with it being a file-level rather than object-level check.

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aanwezigheid_maaiveldhoogte.sch](../../validation_schemas/abstract_patterns/v12/bestand/aanwezigheid_maaiveldhoogte.sch)
