---
type: Test Subsystem
title: Rule and object coverage checks
description: Lightweight cross-checks that every documented rule is implemented, and that a rule's asserts touch the object types it claims to.
resource: scripts/check_rule_coverage.sh
tags: testing
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../scripts/check_rule_coverage.sh"
    title: "check_rule_coverage.sh"
  - resource: "../../scripts/check_rule_object_coverage.sh"
    title: "check_rule_object_coverage.sh"
---

# Overview

Two small, fast (no external dependencies) consistency checks guard against
the rule catalog (`doc/NLCSValidatieRegels.xml`) and the Schematron
implementation ([schematron-layering](../architecture/schematron-layering))
drifting apart:

- **`scripts/check_rule_coverage.sh`** — greps rule numbers out of
  `doc/NLCSValidatieRegels.xml` (`nummer="R.n"`) and phase ids out of
  `validation_schemas/base/v12.sch` (`id="R.n"`), diffs the two sets, and
  emits GitHub Actions annotations for any rule documented but not
  implemented, or implemented but not documented. Runs standalone as the
  `RuleCoverage` workflow (no build step needed) — see
  [ci/workflows](../ci/workflows).

- **`scripts/check_rule_object_coverage.sh`** — for each rule's
  [test fixture](./rule-test-fixtures) SVRL reports, runs
  `transformations/check_object_coverage.xsl` against
  `doc/NLCSValidatieRegels.xml` to confirm the NLCS object types a rule's
  asserts actually reported on match the `<validatieObjecten>` list declared
  for that rule in the catalog. Posts a coverage table
  (Rule/Expected/Found/Missing/Extra) to `$GITHUB_STEP_SUMMARY` and fails CI
  on any mismatch. Runs as the last step of the `RuleValidation` workflow,
  after fixtures have already been validated.
