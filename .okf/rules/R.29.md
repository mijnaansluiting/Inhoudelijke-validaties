---
type: Validation Rule
title: R.29 — Verplaatsing goed vastgelegd
description: Checks that a cable relocation (Bewerking VERPLAATSEN) is recorded as a pair of objects — the original BESTAAND object and a new REVISIE object sharing the same GisId — rather than as a single mutated object.
resource: validation_schemas/patterns/v12/R.29.sch
tags: consistentie
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

A relocation ("verplaatsing") of a cable must be recorded as two objects of the same type: the existing object being moved (Status=BESTAAND) and a new object capturing the new geometry (Status=REVISIE, Bewerking=VERPLAATSEN). This rule checks that whenever an object is flagged as a relocation, a matching original object with the same GisId still exists, and that the relocation object itself carries no AssetId.

# Details

- soort: Consistentie
- validatieObjecten: LSkabel, MSkabel
- Condition:
  - For any MSkabel/LSkabel with Status=REVISIE and Bewerking=VERPLAATSEN ("is_verplaatsing"):
    - it must not have an AssetId (`verplaatsing-cannot-have-asset-id`, message `property-not-allowed-for-statuses`);
    - there must exist a second object of the same NLCS type elsewhere in the file with Status=BESTAAND and the same GisId (`verplaatsing-correctly-applied`, message `verplaatsing-incorrectly-applied`).
  - Objects that are not a relocation (`is_verplaatsing` false) are not constrained by either assertion.

This relocation pattern is the explicit exception referenced by [R.5](/rules/R.5.md), whose GisId/AssetId presence check otherwise excludes REVISIE+VERPLAATSEN objects from its normal "must carry GisId and AssetId" requirement.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verplaatsing_goed_vastgelegd.sch](../../validation_schemas/abstract_patterns/v12/consistentie/verplaatsing_goed_vastgelegd.sch)
