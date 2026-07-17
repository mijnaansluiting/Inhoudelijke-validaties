---
type: Validation Rule
title: R.25 — Verbonden kabels juiste Fase
description: Checks that cables joined at a mof have a Fase combination that is valid for the number of cables connected.
resource: validation_schemas/patterns/v12/R.25.sch
tags: inhoud-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

The set of Fase values on the cables meeting at a joint must be electrically consistent: cables spliced together must carry the same phase(s), except at a designated 3-phase-to-single-phase transition joint where the phases are expected to split.

# Details

- Rule category (`soort`): Inhoud waarde
- Applies to (`validatieObjecten`): LSmof, MSmof
- Behaviour depends on the number of cables connected to the joint:

  | Cables connected | Requirement |
  |---|---|
  | 1 | No check performed |
  | 2 | Fase of both cables must be equal |
  | 3 | Fase of all three cables must be equal |
  | 4 | One cable must be "3 Fasen"; the other three must together be exactly L1, L2 and L3 (a 3-phase to 3×1-phase transition) |
  | >4 | No check performed |

- Only Fase values within the allowed set ("3 Fasen", "L1", "L2", "L3") are permitted at joints with 2, 3 or 4 connections; any other Fase value present triggers a separate assertion.
- For 4 connections, the rule additionally requires that the four distinct allowed phase values are all represented (i.e., the combined value plus all three split values).

See [R.26](./R.26), which also keys its check off the number of cables connected to a joint. The mof-to-kabel touch check is served by a shared connectivity index rather than a per-rule scan; see [connectivity-index-and-geometry-caching](../decisions/connectivity-index-and-geometry-caching).

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](../domain/scope-severity-model) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verbonden_kabels_juiste_fase.sch](../../validation_schemas/abstract_patterns/v12/inhoud_waarde/verbonden_kabels_juiste_fase.sch)
