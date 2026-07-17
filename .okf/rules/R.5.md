---
type: Validation Rule
title: R.5 — GisId en AssetId
description: Checks that objects originating from asset registration (Status BESTAAND, REVISIE, or VERWIJDERD) carry a GisId and AssetId, while newly designed objects (Status NIEUW) do not.
resource: validation_schemas/patterns/v12/R.5.sch
tags: verplichte-waarde
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

Objects with Status BESTAAND, REVISIE, or VERWIJDERD originate from the asset registration and must therefore carry both a GisId and an AssetId. Conversely, objects with Status NIEUW are created during design or revision and must not have these identifiers filled in.

# Details

- soort: Verplichte waarde
- validatieObjecten: AlleObjecten (applies to all NLCS object types)
- Condition:
  - If Status is one of BESTAAND, REVISIE, or VERWIJDERD, then GisId and AssetId must both be present (subject to the per-object exceptions below).
  - If Status is NIEUW, then GisId and AssetId must both be empty.
  - Objects with Status = REVISIE and Bewerking = VERPLAATSEN are excluded entirely from this check (context excludes them) — see [R.29](./R.29) for the relocation ("verplaatsen") exception rule.
  - Whether an object actually requires a GisId/AssetId is determined by `ma:object-requires-gis-id` / `ma:object-requires-asset-id`, which consult a configured exception list rather than requiring it unconditionally for every object type.

This rule has a configured exception: `configuration/sys_config.xml`'s `GisIdAssetsIdExceptions/NoGisIdRequired` lists `AmantelbuisInhoud` as an object type that never requires a GisId; see [sys_config reference](../config/sys-config).

Severity for this rule varies by scope; see [scope × severity matrix](../domain/scope-severity-model) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [gisid_en_assetid.sch](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/gisid_en_assetid.sch)
