---
type: Validation Rule
title: R.26 — Aantal kabels en mof functie
description: Checks that the number of cables connected to a joint matches what is expected for the joint's Functie.
resource: validation_schemas/patterns/v12/R.26.sch
tags: [inhoud-waarde]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

A joint's Functie (function) implies how many cables should physically meet there — an end cap has one cable, a straight splice has two, a branch has three. This rule verifies the actual connected cable count against the count implied by Functie, and additionally checks the special case of a branch joint on an existing cable.

# Details

- Rule category (`soort`): Inhoud waarde
- Applies to (`validatieObjecten`): Eaardmof, LSmof, MSmof
- Functie is first mapped to a functional category via `ma:map-mof-functie` (see config dependency below), then the required number of connected cables is derived:

  | Functie category | Example Functie values | Required cables |
  |---|---|---|
  | Eind | EINDMOF, EINDDOP, LOODKOP, EIND GEAARD | 1 |
  | Verbinding | VERBINDING, ZEGELWIJZIGING, MANTELREPARATIE | 2 |
  | Faseovergang | 3FASE 3x1FASE | 4 |
  | Aftak, on an existing cable (at least one connected cable has Status "BESTAAND") | AFTAK SPLITSEND | 2, and at least one connected cable must have Status "NIEUW" |
  | Aftak, otherwise | AFTAK SPLITSEND | 3 |

- If Functie cannot be mapped to a known category, a separate assertion flags that the required cable amount is unknown.
- Eaardmof has no Functie; instead it must simply be connected to at least one Eaarddraad (a dedicated rule branch, not driven by the table above).

Config dependency: the mapping from Functie strings to the Aftak/Eind/Verbinding/Faseovergang categories is defined by the `MofFuncties` group in `configuration/sys_config.xml` and read via the `ma:map-mof-functie` function — see [/config/sys-config.md](/config/sys-config.md).

The mof-to-kabel/Eaarddraad touch check is served by a shared connectivity index rather than a per-rule scan; see [connectivity-index-and-geometry-caching](/decisions/connectivity-index-and-geometry-caching.md).

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](/domain/scope-severity-model.md) for the full scope×severity matrix.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [aantal_kabels_en_mof_functie.sch](../../validation_schemas/abstract_patterns/v12/inhoud_waarde/aantal_kabels_en_mof_functie.sch)
