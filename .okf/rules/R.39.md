---
type: Validation Rule
title: R.39 — Mof verbonden kabels gelijk verbindingnummer
description: Checks that MS/LSkabel objects physically connected to a MS/LSmof share that mof's Verbindingnummer value.
resource: validation_schemas/patterns/v12/R.39.sch
tags: inhoud-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A mof (cable joint) and the cables that connect to it should belong to the same logical connection, so this rule requires that every LSkabel/MSkabel whose geometry touches an LSmof/MSmof's point geometry has the same Verbindingnummer as that mof.

# Details

- soort: Inhoud waarde
- validatieObjecten: LSmof, MSmof
- Condition: for an LSmof, the set of LSkabel objects whose line geometry touches the mof's point geometry (`ma:point-touches-line`) must all have `Verbindingnummer` equal to the mof's `Verbindingnummer`; the same check is applied for MSmof against connected MSkabel objects.

The abstract pattern emits the `connected-cables-have-different-verbindingnummer` message from the message catalog; see [localization-messages](/config/localization-messages.md). This rule complements [R.23](/rules/R.23.md), which also checks Verbindingnummer consistency across connected cables.

The mof-to-kabel touch check is served by a shared connectivity index rather than a per-rule scan; see [connectivity-index-and-geometry-caching](/decisions/connectivity-index-and-geometry-caching.md).

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [mof_verbonden_kabels_gelijk_verbindingnummer.sch](../../validation_schemas/abstract_patterns/v12/inhoud_waarde/mof_verbonden_kabels_gelijk_verbindingnummer.sch)
