---
type: Validation Rule
title: R.1 — Bestand bevat NLCS Objecten
description: Checks that an NLCS++ file contains exactly one AprojectReferentie plus at least one actual NLCS object, so no "empty" project can be submitted.
resource: validation_schemas/patterns/v12/R.1.sch
tags: bestand
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

An NLCS++ file must contain at least one NLCS object in addition to its project reference. This rule rejects files that consist only of an AprojectReferentie with no actual content, i.e. an "empty" project submission.

# Details

- soort: Bestand
- validatieObjecten: Document
- Condition: the file's NLCSnetbeheer element must contain exactly one AprojectReferentie (`count($aprojectreferenties) = 1`), and it must contain at least one other child element that is not an AprojectReferentie (`count($nlcs_objects) > 0`).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [bestand_bevat_nlcs_objecten.sch](../../validation_schemas/abstract_patterns/v12/bestand/bestand_bevat_nlcs_objecten.sch)
