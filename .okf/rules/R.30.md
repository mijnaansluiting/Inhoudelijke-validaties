---
type: Validation Rule
title: R.30 — Mantelbuis Inhoud referenties
description: Checks that an AmantelbuisInhoud correctly references a surrounding Amantelbuis and a distinct content object of the declared ObjectTypeInhoud.
resource: validation_schemas/patterns/v12/R.30.sch
tags: consistentie
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

An AmantelbuisInhoud object links a duct (mantelbuis) to the asset it contains. This rule checks that the two references are internally consistent: the content ID must differ from the duct ID, MantelbuisID must actually point to an Amantelbuis object, and InhoudID must point to an object whose type matches the declared ObjectTypeInhoud.

# Details

- soort: Consistentie
- validatieObjecten: AmantelbuisInhoud
- Condition:
  - `mantelbuis-inhoud-is-not-self`: InhoudID must not equal MantelbuisID (message `mantelbuis-inhoud-is-self`).
  - `mantelbuis-id-refers-to-mantelbuis`: the NLCS object with ID = MantelbuisID must exist and be an Amantelbuis (message `mantelbuis-id-does-not-refer-to-mantelbuis`).
  - `object-type-inhoud-matches-inhoud`: the NLCS object with ID = InhoudID must have a type name matching the AmantelbuisInhoud's own ObjectTypeInhoud value (message `object-type-inhoud-does-not-match-inhoud`).

This rule is closely related to [R.27](/rules/R.27.md) and [R.36](/rules/R.36.md), which impose further consistency and geometric constraints on the same mantelbuis/inhoud relationship.

Severity for this rule varies by scope; see [scope × severity matrix](/domain/scope-severity-model.md) for the exact values.

# Citations

[1] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
[2] [mantelbuis_inhoud_referenties.sch](../../validation_schemas/abstract_patterns/v12/consistentie/mantelbuis_inhoud_referenties.sch)
