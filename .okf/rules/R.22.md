---
type: Validation Rule
title: R.22 — Kabels zelfde Netvlak
description: Checks that cables connected to each other through a joint belong to the same network layer (discipline).
resource: validation_schemas/patterns/v12/R.22.sch
tags: [netlogica]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

Cables that are physically joined via a mof must belong to the same netvlak (network layer/discipline) — an LSkabel should not be spliced directly to an MSkabel or HSkabel, and vice versa, since that would mix voltage levels on one continuous conductor.

# Details

- Rule category (`soort`): Netlogica
- Applies to (`validatieObjecten`): LSkabel, MSkabel
- For an MSkabel, the joints (MSmof) touching its line are found, and then any LSkabel or HSkabel that also touches one of those joints is collected; the assertion fails if any such cross-netvlak cable is found.
- For an LSkabel, the joints (LSmof) touching its line are found, and then any MSkabel or HSkabel touching one of those joints is collected; the assertion fails if any such cross-netvlak cable is found.
- In both cases the failure message reports the counts and types of the mismatching connected cables.

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [kabels_zelfde_netvlak.sch](../../validation_schemas/abstract_patterns/v12/netlogica/kabels_zelfde_netvlak.sch)
