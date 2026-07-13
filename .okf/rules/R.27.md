---
type: Validation Rule
title: R.27 — Mantelbuis past in mantelbuis
description: Checks that a protection pipe (mantelbuis) nested inside one or more other protection pipes has a smaller diameter than each of them.
resource: validation_schemas/patterns/v12/R.27.sch
tags: inhoud-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A mantelbuis can be laid inside one or more other, larger mantelbuizen, as recorded via AmantelbuisInhoud. For this physical nesting to be plausible, the inner pipe's Diameter must be smaller than the Diameter of every outer pipe it is recorded as lying inside.

# Details

- Rule category (`soort`): Inhoud waarde
- Applies to (`validatieObjecten`): Amantelbuis
- For a given Amantelbuis, the AmantelbuisInhoud records that reference it as InhoudID identify the parent (outer) mantelbuizen it lies inside.
- The assertion requires that the inner pipe's Diameter is strictly smaller than the Diameter of every one of those outer pipes.
- Diameter is a Text-typed attribute in the data model, so the abstract pattern coerces it to `number()` before comparing; outer pipes whose Diameter is "KEUZE ONTBREEKT IN LIJST" (no choice made) are excluded from the comparison, and the check is skipped entirely if the inner pipe's own Diameter is "KEUZE ONTBREEKT IN LIJST". Note: an earlier version of this pattern had a bug around this numeric coercion (missing xs:decimal/xs:integer conversion), later fixed.

See [R.30](/rules/R.30.md), which also concerns mantelbuis/inhoud nesting relationships.

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [mantelbuis_past_in_mantelbuis.sch](../../validation_schemas/abstract_patterns/v12/inhoud_waarde/mantelbuis_past_in_mantelbuis.sch)
