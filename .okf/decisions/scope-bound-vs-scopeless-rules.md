---
type: Decision
title: Bestand-category rules are severity-scopeless
description: Why file-level rules like R.1/R.2/R.35/R.40 always report severity "Fout" instead of being matched against a scope.
tags: [decision, scope]
timestamp: 2026-07-08T00:00:00Z
---

# Context

[Rule severity](/domain/scope-severity-model.md) is normally computed by
matching the object under validation (its Tekeningsoort/Status/
Bedrijfstoestand) against one of the 8 scopes, then looking up that rule's
`niveau` within the matched scope. That matching only works when the rule's
Schematron `<rule context>` fires on a per-object basis.

Rules of `soort` **Bestand** ([R.1](/rules/R.1.md), [R.2](/rules/R.2.md),
[R.35](/rules/R.35.md), [R.40](/rules/R.40.md)) don't fit that model — they
assert something about the *file as a whole* (context `//nlcs:NLCSnetbeheer`
or `AprojectReferentie`), not about an individual NLCS object with its own
Status/Bedrijfstoestand. There is no single "object" to compute a scope from.

# Decision

`ma:rule-severity-within-scope` (in
[rule_scope_functions.xsl](/architecture/xsl-function-libraries.md))
special-cases rules whose `ma:rule-type` is `Bestand`: rather than attempting
scope matching, it unconditionally returns `Fout`. This is why
[scope-severity-model](/domain/scope-severity-model.md)'s matrix shows
`R.1`, `R.2`, and `R.35` as `Fout` in literally every scope — the rule
simply isn't scope-dependent at all. (`R.40` is the same mechanism, but its
*own* check logic only applies when Tekeningtype is `DEELREVISIE`/
`EINDREVISIE`, which is why it shows `–` for the other two Tekeningsoorten
rather than because of scope matching.)

# History

This wasn't the original design. Two fixes got here incrementally:

1. **`e365bcb` — "R.1 and R.2 always explicitly within scope"** (2026-01-15).
   The original code special-cased `object_type = 'NLCSnetbeheer'` to mean
   "always in scope", but that check didn't reliably identify which rules
   needed it. The fix replaced it with an explicit rule-number allowlist:
   `$rule_numbers_always_within_scope = (1, 2)`.

2. **`f519af4` — "Scopeless rules consistency" (#88)** (2026-04-14). The
   allowlist-of-rule-numbers approach was replaced with the current
   category-based check (`$rule_type = 'Bestand'`), which generalizes to
   *any* Bestand rule (including `R.35`/`R.40`) instead of needing every new
   file-level rule added to a hardcoded list. This PR also reworked
   [R.2](/rules/R.2.md)'s own abstract pattern
   (`combinatie_nlcs_status_en_tekeningsoort.sch`) to evaluate all objects'
   statuses in one file-level assert (`distinct-values(*/nlcs:Status)`)
   instead of one assert per object, and consolidated the corresponding
   [test fixtures](/testing/rule-test-fixtures.md) (many near-duplicate
   per-object-type failing fixtures collapsed into one per Tekeningsoort).

# Why this matters

If a future rule is added with `soort` Bestand, it will automatically be
`Fout`-severity everywhere via the category check — no scope-table entry is
needed, and none should be added, since [scope-coverage-tests](/testing/scope-coverage-tests.md)
tests object-level scope matching, not file-level rules.

# Citations

[1] [e365bcb — R.1 and R.2 always explicitly within scope](https://github.com/mijnaansluiting/Inhoudelijke-validaties/commit/e365bcb213b4cc0e05f4c5efcda50974e9e489ec)
[2] [f519af4 — Scopeless rules consistency (#88)](https://github.com/mijnaansluiting/Inhoudelijke-validaties/commit/f519af4517d2a4c181b90ede1096bf24d841ddd4)
[3] [rule_scope_functions.xsl](../../validation_schemas/xsl_functions/rule_scope_functions.xsl)
