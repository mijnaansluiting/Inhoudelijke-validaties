---
type: Validation Rule
title: R.7 — Subnettype gevuld voor LS en MS Kabel
description: Checks that MSkabel, LSkabel, and LSmof objects have a value for Subnettype.
resource: validation_schemas/patterns/v12/R.7.sch
tags: verplichte-waarde
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../validation_schemas/abstract_patterns/v12/verplichte_waarde/subnettype_ingevuld_voor_ls_en_ms_kabel.sch"
    title: "subnettype_ingevuld_voor_ls_en_ms_kabel.sch"
---

# Overview

MSkabel, LSkabel, and LSmof objects must specify their Subnettype so that the sub-network they belong to is always identifiable.

# Details

- soort: Verplichte waarde
- validatieObjecten: MSkabel, LSkabel, LSmof
- Condition: for each object of these types, `nlcs:Subnettype` must be present and non-empty.

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
