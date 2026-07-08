---
type: Validation Rule
title: R.7 — Subnettype gevuld voor LS en MS Kabel
description: Checks that MSkabel, LSkabel, and LSmof objects have a value for Subnettype.
resource: validation_schemas/patterns/v12/R.7.sch
tags: [verplichte-waarde]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

MSkabel, LSkabel, and LSmof objects must specify their Subnettype so that the sub-network they belong to is always identifiable.

# Details

- soort: Verplichte waarde
- validatieObjecten: MSkabel, LSkabel, LSmof
- Condition: for each object of these types, `nlcs:Subnettype` must be present and non-empty.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [subnettype_ingevuld_voor_ls_en_ms_kabel.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/subnettype_ingevuld_voor_ls_en_ms_kabel.sch)
