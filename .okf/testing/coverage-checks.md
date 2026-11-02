---
type: Test Subsystem
title: Rule and object coverage checks
description: Lightweight cross-checks that every documented rule is implemented, and that a rule's asserts touch the object types it claims to.
resource: scripts/check_rule_coverage.sh
tags: testing
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../scripts/check_rule_coverage.sh"
    title: "check_rule_coverage.sh"
  - resource: "../../scripts/check_rule_object_coverage.sh"
    title: "check_rule_object_coverage.sh"
---

# Overview

Two small, fast (no external dependencies) consistency checks guard against
a version's rule catalog (`<version>/doc/NLCSValidatieRegels.xml`) and the Schematron
implementation ([schematron-layering](../architecture/schematron-layering))
drifting apart:

- **`scripts/check_rule_coverage.sh`** — greps rule numbers out of
  `<version>/doc/NLCSValidatieRegels.xml` (`nummer="R.n"`) and phase ids out of
  `<version>/rules/main.sch` (`id="R.n"`), diffs the two sets, and
  emits GitHub Actions annotations for any rule documented but not
  implemented, or implemented but not documented. Runs in the
  first `covered-rules` job of the `CI` workflow (no build step needed) — see
  [ci/workflows](../ci/workflows).

- **`scripts/check_rule_object_coverage.sh`** — for each rule's
  [test fixture](./rule-test-fixtures) SVRL reports, runs
  `transformations/check_object_coverage.xsl` against
  `<version>/doc/NLCSValidatieRegels.xml` (it reads the failing reports from
  `../<version>/rule_validation_reports/`) to confirm the NLCS object types a rule's
  asserts actually reported on match the `<validatieObjecten>` list declared
  for that rule in the catalog. Posts a coverage table
  (Rule/Expected/Found/Missing/Extra) to `$GITHUB_STEP_SUMMARY` and fails CI
  on any mismatch. Runs as the last step of the `validate-rules` CI job,
  after fixtures have already been validated.
