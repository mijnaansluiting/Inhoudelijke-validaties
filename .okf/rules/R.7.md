---
type: Validation Rule
title: R.7 — Subnettype gevuld voor LS en MS Kabel
description: Checks that MSkabel, LSkabel, and LSmof objects have a value for Subnettype.
resource: v12/rules/patterns/R.7.sch
tags: verplichte-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12/rules/abstract_patterns/verplichte_waarde/subnettype_ingevuld_voor_ls_en_ms_kabel.sch"
    title: "subnettype_ingevuld_voor_ls_en_ms_kabel.sch"
---

# Overview

MSkabel, LSkabel, and LSmof objects must specify their Subnettype so that the sub-network they belong to is always identifiable.

# Details

- soort: Verplichte waarde
- validatieObjecten: MSkabel, LSkabel, LSmof
- Condition: for each object of these types, `nlcs:Subnettype` must be present and non-empty.

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.
