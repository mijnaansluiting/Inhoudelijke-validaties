---
type: Validation Rule
title: R.8 — Verplichte kenmerken Kabels
description: Checks that every cable has values for a core set of mandatory attributes, with three additional mandatory attributes for LSkabel.
resource: validation_schemas/patterns/v12/R.8_A.sch
tags: [verplichte-waarde]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

Every cable object must carry a baseline set of descriptive attributes (execution, cable construction, manufacturer, connection number, voltage level, phase indication). LSkabel objects additionally must record earthing system, whether they run above ground, and their function.

# Details

- soort: Verplichte waarde
- validatieObjecten: HSkabel, LSkabel, MSkabel
- This rule is implemented as two Schematron sub-checks:
  - **R.8-A** (general, HSkabel/LSkabel/MSkabel): `nlcs:Uitvoering`, `nlcs:Kabelopbouw`, `nlcs:Fabrikant`, `nlcs:Verbindingnummer`, `nlcs:Spanningsniveau`, and `nlcs:FaseAanduiding` must all be present and non-empty. In addition, if `nlcs:Uitvoering` equals `KEUZE ONTBREEKT IN LIJST`, then `nlcs:OmschrijvingUitvoering` must also be present and non-empty.
  - **R.8-B** (LSkabel only): `nlcs:Aardingsysteem`, `nlcs:Bovengronds`, and `nlcs:Functie` must all be present and non-empty, in addition to the R.8-A attributes.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [verplichte_kenmerken_kabels.sch (R.8-A)](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_kabels.sch), [verplichte_kenmerken_kabels-ls_extra.sch (R.8-B)](../../validation_schemas/abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_kabels-ls_extra.sch)
