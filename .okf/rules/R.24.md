---
type: Validation Rule
title: R.24 — Fase MS Kabel
description: Checks that a cable's FaseAanduiding value is consistent with its Uitvoering value.
resource: v12.1/rules/patterns/R.24.sch
tags: inhoud-waarde
generated:
  by: claude-code/opus-5-5
  at: 2026-11-10T00:00:00Z
sources:
  - resource: "../../v12.1/doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog"
  - resource: "../../v12.1/rules/abstract_patterns/inhoud_waarde/fase_ms_kabel.sch"
    title: "fase_ms_kabel.sch"
---

# Overview

A cable's declared Fase (phase) must match how the cable is actually constructed, as described by Uitvoering: a 3-phase cable should be built as a "3x" execution, while a single-phase cable (L1, L2 or L3) should be built as a "1x" execution.

# Details

- Rule category (`soort`): Inhoud waarde
- Applies to (`validatieObjecten`): MSkabel
- Expected prefix of Uitvoering derived from FaseAanduiding:

  | FaseAanduiding | Expected Uitvoering prefix |
  |---|---|
  | 3 Fasen | "3x" |
  | L1 / L2 / L3 | "1x" |
  | N (or any other value) | no prefix required |

- The assertion checks that Uitvoering starts with the expected prefix.
- If Uitvoering equals "KEUZE ONTBREEKT IN LIJST" (no choice made in the list), OmschrijvingUitvoering is compared against the expected prefix instead.

Severity for this rule varies by scope; see [/domain/scope-severity-model.md](../domain/scope-severity-model) for the full scope×severity matrix.
