---
type: Test Subsystem
title: Scope coverage tests
description: A meta-test verifying the scope/severity engine itself assigns exactly the right rules to every scope, with no gaps or overlaps.
resource: test/scope_validation_data/v12/scope_template.xml
tags: [testing]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

This test suite doesn't validate end-user NLCS++ data — it validates that
the [scope/severity model](/domain/scope-severity-model.md) itself has full,
non-overlapping coverage. `test/scope_validation_data/v12/scope_template.xml`
is expanded by `transformations/generate_scoped_objects.xsl` into one XML
object per (scope × Tekeningtype × Status × Bedrijfstoestand) combination —
every cell of the scope matrix gets its own tiny test object.

`scripts/validate_scopes.sh` then, for each generated object:
1. Runs it through the **scope-checked** schema
   (`validation_schemas/base_scope_checks/v12.xsl` — see
   [compilation-pipeline](/architecture/compilation-pipeline.md)), whose
   abstract patterns assert an object's actual scope membership.
2. Compares the resulting SVRL (via `transformations/check_scope_coverage.xsl`)
   against the expected rule set for that scope, reporting `expected` /
   `found` / `missing` / `unexpected` rule lists.
3. Fails CI with a `$GITHUB_STEP_SUMMARY` table ("Onvolledige of onjuiste
   scopedekking") if any scope has missing or unexpected rules.

This runs as the `ScopeValidation` workflow — see
[ci/workflows](/ci/workflows.md). It's the reason
[scope-bound-vs-scopeless-rules](/decisions/scope-bound-vs-scopeless-rules.md)
exists as a decision record: gaps caught by this suite are what drove past
fixes to which rules are unconditionally in-scope.

# Citations

[1] [validate_scopes.sh](../../scripts/validate_scopes.sh)
[2] [scope_template.xml](../../test/scope_validation_data/v12/scope_template.xml)
