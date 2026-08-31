---
type: Domain Concept
title: Scope and severity model
description: How the same rule can be an error in one drawing context and merely informational in another.
resource: doc/NLCSValidatieRegels.xml
tags: domain, scope, severity
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../doc/NLCSValidatieRegels.xml"
    title: "NLCS Validatieregels catalog \u2014 `<scopes>` section"
  - resource: "../../validation_schemas/xsl_functions/rule_scope_functions.xsl"
    title: "rule_scope_functions.xsl"
---

# Overview

A single validation rule (e.g. [R.36](../rules/R.36)) does not always carry
the same severity. Whether a failed rule is a hard error (`Fout`), merely
`Informerend` (informational), or a `Waarschuwing` (warning) depends on the
**scope** the object under validation falls into — a combination of:

- **Tekeningsoort** (drawing type): `Bestaande Situatie`, `Definitief
  Ontwerp`, `Deelrevisie`, `Eindrevisie`
- **Status**: `BESTAAND`, `NIEUW`, `REVISIE`, `VERWIJDERD`
- **Bedrijfstoestand** (operational state): `IN BEDRIJF`, `RESERVE`,
  `VERLATEN`

`doc/NLCSValidatieRegels.xml`'s `<scopes>` section defines 8 named scopes,
each mapping a Tekeningsoort+Status+Bedrijfstoestand combination to a list of
rules and, per rule, a `niveau` (severity). This lets the same physical check
(e.g. "does a cable have valid endpoints") be strictly enforced during a final
handover but only advisory during an as-built ("Bestaande Situatie") capture.

This logic is implemented in `validation_schemas/xsl_functions/rule_scope_functions.xsl`
via functions like `ma:scope-name`, `ma:rule-severity-within-scope`, and
`ma:rule-within-scope-for-object`, and consumed by every concrete pattern in
`validation_schemas/patterns/v12/` (see
[schematron-layering](../architecture/schematron-layering)) to populate the
`scope` and `severity` properties attached to every Schematron assert.

# The 8 scopes

| Scope | Tekeningsoort | Status | Bedrijfstoestand |
|---|---|---|---|
| Bestaande Situatie | Bestaande Situatie | BESTAAND | IN BEDRIJF, RESERVE, VERLATEN |
| Definitief Ontwerp | Definitief Ontwerp | NIEUW, REVISIE, VERWIJDERD | IN BEDRIJF, RESERVE, VERLATEN |
| Deelrevisie nieuwe objecten | Deelrevisie | NIEUW | IN BEDRIJF |
| Deelrevisie aangepaste objecten | Deelrevisie | REVISIE | IN BEDRIJF, RESERVE |
| Deelrevisie verlaten objecten | Deelrevisie | REVISIE, VERWIJDERD | VERLATEN |
| Eindrevisie nieuwe objecten | Eindrevisie | NIEUW | IN BEDRIJF |
| Eindrevisie aangepaste objecten | Eindrevisie | REVISIE | IN BEDRIJF, RESERVE |
| Eindrevisie verlaten objecten | Eindrevisie | REVISIE, VERWIJDERD | VERLATEN |

# Rule severity per scope

`F` = Fout (error), `I` = Informerend (informational), `W` = Waarschuwing
(warning), `–` = rule is not evaluated for this scope at all.

| Rule | Bestaande Situatie | Definitief Ontwerp | Deelrevisie nieuw | Deelrevisie aangepast | Deelrevisie verlaten | Eindrevisie nieuw | Eindrevisie aangepast | Eindrevisie verlaten |
|---|---|---|---|---|---|---|---|---|
| [R.1](../rules/R.1) | F | F | F | F | F | F | F | F |
| [R.2](../rules/R.2) | F | F | F | F | F | F | F | F |
| [R.3](../rules/R.3) | F | F | F | F | F | F | F | F |
| [R.4](../rules/R.4) | – | – | F | F | F | F | F | F |
| [R.5](../rules/R.5) | F | F | F | F | F | F | F | F |
| [R.6](../rules/R.6) | F | – | F | F | F | F | F | F |
| [R.7](../rules/R.7) | F | F | F | F | F | F | F | F |
| [R.8](../rules/R.8) | I | – | F | F | – | F | F | – |
| [R.9](../rules/R.9) | I | – | F | F | – | F | F | – |
| [R.10](../rules/R.10) | I | – | F | F | – | F | F | – |
| [R.11](../rules/R.11) | I | – | F | F | – | F | F | – |
| [R.12](../rules/R.12) | I | – | F | F | – | F | F | – |
| [R.13](../rules/R.13) | I | – | F | F | – | F | F | – |
| [R.14](../rules/R.14) | I | – | F | F | – | F | F | – |
| [R.15](../rules/R.15) | I | – | F | F | – | F | F | – |
| [R.20](../rules/R.20) | I | F | F | F | – | F | F | – |
| [R.21](../rules/R.21) | I | – | I | I | – | F | F | – |
| [R.22](../rules/R.22) | I | – | I | I | – | F | F | – |
| [R.23](../rules/R.23) | I | – | I | I | – | F | F | – |
| [R.24](../rules/R.24) | I | – | F | F | – | F | F | – |
| [R.25](../rules/R.25) | I | – | F | F | – | F | F | – |
| [R.26](../rules/R.26) | I | – | I | I | – | F | F | – |
| [R.27](../rules/R.27) | I | F | F | F | – | F | F | – |
| [R.28](../rules/R.28) | I | F | F | F | – | F | F | – |
| [R.29](../rules/R.29) | – | – | F | F | – | F | F | – |
| [R.30](../rules/R.30) | I | F | F | F | – | F | F | – |
| [R.31](../rules/R.31) | – | – | W | – | – | F | – | – |
| [R.32](../rules/R.32) | – | – | W | – | – | F | – | – |
| [R.33](../rules/R.33) | – | – | W | – | – | F | – | – |
| [R.34](../rules/R.34) | – | – | – | – | F | – | – | F |
| [R.35](../rules/R.35) | F | F | F | F | F | F | F | F |
| [R.36](../rules/R.36) | F | F | F | F | – | F | F | – |
| [R.37](../rules/R.37) | – | – | F | – | – | F | – | – |
| [R.38](../rules/R.38) | – | – | W | – | – | W | – | – |
| [R.39](../rules/R.39) | – | – | F | – | – | F | – | – |
| [R.40](../rules/R.40) | – | – | F | F | F | F | F | F |
| [R.41](../rules/R.41) | F | F | F | F | F | F | F | F |

Rules `R.1`, `R.2`, `R.3`, `R.5`, `R.7`, `R.35`, and `R.41` are the only rules
that are `Fout` in literally every scope — regardless of drawing type,
status, or operational state. See
[scope-bound-vs-scopeless-rules](../decisions/scope-bound-vs-scopeless-rules)
for why `R.1`/`R.2` specifically were made unconditionally in-scope.
