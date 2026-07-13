---
type: Validation Rule
title: R.28 — Mantelbuis Inhoud aanwezig
description: Checks that a protection pipe (mantelbuis) in use has a registered content and a reserve one does not.
resource: validation_schemas/patterns/v12/R.28.sch
tags: consistentie
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

Whether a mantelbuis is expected to have an AmantelbuisInhoud (its recorded content, e.g. a cable) depends on its Bedrijfstoestand: a pipe that is in service should have content registered, while a pipe kept in reserve should not.

# Details

- Rule category (`soort`): Consistentie
- Applies to (`validatieObjecten`): Amantelbuis
- If Bedrijfstoestand is "IN BEDRIJF", at least one AmantelbuisInhoud referencing the mantelbuis (via MantelbuisID) must exist.
- If Bedrijfstoestand is "RESERVE", no AmantelbuisInhoud referencing the mantelbuis may exist.
- Both conditions are checked as separate assertions on the same rule context.

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [mantelbuis_inhoud_aanwezig.sch](../../validation_schemas/abstract_patterns/v12/consistentie/mantelbuis_inhoud_aanwezig.sch)
