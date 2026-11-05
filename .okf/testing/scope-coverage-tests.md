---
type: Test Subsystem
title: Scope coverage tests
description: A meta-test verifying the scope/severity engine itself assigns exactly the right rules to every scope, with no gaps or overlaps.
resource: v12.1/test/scope_validation_data/scope_template.xml
tags: testing
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../scripts/validate_scopes.sh"
    title: "validate_scopes.sh"
  - resource: "../../v12.1/test/scope_validation_data/scope_template.xml"
    title: "scope_template.xml"
---

# Overview

This test suite doesn't validate end-user NLCS++ data — it validates that
the [scope/severity model](../domain/scope-severity-model) itself has full,
non-overlapping coverage. `<version>/test/scope_validation_data/scope_template.xml`
is expanded by `transformations/generate_scoped_objects.xsl` (reading the
scopes from `<version>/doc/NLCSValidatieRegels.xml`) into
`<version>/scoped_objects/`, one XML object per (scope × Tekeningtype × Status × Bedrijfstoestand) combination —
every cell of the scope matrix gets its own tiny test object.

`scripts/validate_scopes.sh` then, for each generated object:
1. Runs it through the **scope-checked** schema
   (`<version>/rules/transpiled_phases/main_scope_checks.xsl` — see
   [compilation-pipeline](../architecture/compilation-pipeline)), whose
   abstract patterns assert an object's actual scope membership; reports go
   to `<version>/scoped_objects_reports/`.
2. Compares the resulting SVRL (via `transformations/check_scope_coverage.xsl`)
   against the expected rule set for that scope, reporting `expected` /
   `found` / `missing` / `unexpected` rule lists.
3. Fails CI with a `$GITHUB_STEP_SUMMARY` table ("Onvolledige of onjuiste
   scopedekking") if any scope has missing or unexpected rules.

This runs as the `validate-scopes` job of the `CI` workflow — see
[ci/workflows](../ci/workflows). It's the reason
[scope-bound-vs-scopeless-rules](../decisions/scope-bound-vs-scopeless-rules)
exists as a decision record: gaps caught by this suite are what drove past
fixes to which rules are unconditionally in-scope.
