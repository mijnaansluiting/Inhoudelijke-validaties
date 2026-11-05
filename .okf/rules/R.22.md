---
type: Validation Rule
title: R.22 — Kabels zelfde Netvlak
description: Checks that cables connected to each other through a joint belong to the same network layer (discipline).
resource: v12/rules/patterns/R.22.sch
tags: netlogica
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12/rules/abstract_patterns/netlogica/kabels_zelfde_netvlak.sch"
    title: "kabels_zelfde_netvlak.sch"
---

# Overview

Cables that are physically joined via a mof must belong to the same netvlak (network layer/discipline) — an LSkabel should not be spliced directly to an MSkabel or HSkabel, and vice versa, since that would mix voltage levels on one continuous conductor.

# Details

- Rule category (`soort`): Netlogica
- Applies to (`validatieObjecten`): LSkabel, MSkabel
- For an MSkabel, the joints (MSmof) touching its line are found, and then any LSkabel or HSkabel that also touches one of those joints is collected; the assertion fails if any such cross-netvlak cable is found.
- For an LSkabel, the joints (LSmof) touching its line are found, and then any MSkabel or HSkabel touching one of those joints is collected; the assertion fails if any such cross-netvlak cable is found.
- In both cases the failure message reports the counts and types of the mismatching connected cables.

The mof/kabel touch relationship (both the direct touch and the "kabel via a shared mof" second hop) is served by a shared connectivity index rather than a per-rule, per-kabel rescan; see [connectivity-index-and-geometry-caching](../decisions/connectivity-index-and-geometry-caching).

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](../domain/scope-severity-model) for the full scope×severity matrix.
