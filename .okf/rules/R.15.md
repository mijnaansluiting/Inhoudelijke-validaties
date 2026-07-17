---
type: Validation Rule
title: R.15 — Verplichte kenmerken Mantelbuis
description: Checks that every conduit (Mantelbuis) has its Materiaal, Diameter, and Thema attributes populated.
resource: validation_schemas/patterns/v12/R.15.sch
tags: verplichte-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview
This rule verifies that every Mantelbuis (conduit/duct) records its material, diameter, and thematic classification, since these attributes are needed to describe the physical conduit and how it relates to the cables it protects.

# Details
- Rule category (`soort`): Verplichte waarde (mandatory value).
- Applies to (`validatieObjecten`): Amantelbuis.
- Condition: every `Amantelbuis` must have a value for `Materiaal`, `Diameter`, and `Thema` (asserts `mantelbuis-has-materiaal`, `mantelbuis-has-diameter`, `mantelbuis-has-thema`).

This rule only checks that `Diameter` is *populated*; the value's geometric consistency and unit correctness are checked separately — see [R.27](./R.27) and [R.36](./R.36), which apply additional geometric/value checks specific to Amantelbuis and its `Diameter`.

Severity for this rule varies by scope; see [scope-severity-model](../domain/scope-severity-model) for the full scope×severity matrix.

The abstract pattern emits the `attribute-not-present` message from the message catalog for each missing attribute; see [localization-messages](../config/localization-messages).

# Citations
[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verplichte_kenmerken_mantelbuis.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_mantelbuis.sch)
