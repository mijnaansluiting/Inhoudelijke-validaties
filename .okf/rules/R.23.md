---
type: Validation Rule
title: R.23 — Verbonden kabels juiste kenmerken
description: Checks that cables connected to each other via a joint share the same value for a set of key attributes.
resource: validation_schemas/patterns/v12/R.23.sch
tags: netlogica
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

Cables spliced together through a joint represent one continuous circuit, so certain descriptive attributes must be identical across the splice; a mismatch signals a data-entry error or an inconsistent circuit definition.

# Details

- Rule category (`soort`): Netlogica
- Applies to (`validatieObjecten`): LSkabel, MSkabel
- For each MSkabel/LSkabel, the joints (MSmof/LSmof) touching its line are found, and then all other cables of the same type touching one of those joints are collected as "connected cables".
- The rule compares the following attributes of the cable against each connected cable, and reports the distinct mismatching values found:
  - Bedrijfstoestand
  - Subnettype
  - Verbindingnummer
  - Spanningsniveau
- Each attribute is checked with a separate assertion, so a mismatch on one attribute does not suppress the check of the others.

See [R.39](/rules/R.39.md), which also validates a shared attribute — Verbindingnummer — across connected cables/joints. The mof/kabel touch relationship this rule composes (touch, then touch-via-mof) is served by a shared connectivity index rather than a per-kabel rescan; see [connectivity-index-and-geometry-caching](/decisions/connectivity-index-and-geometry-caching.md).

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verbonden_kabels_juiste_kenmerken.sch](../../validation_schemas/abstract_patterns/v12/netlogica/verbonden_kabels_juiste_kenmerken.sch)
