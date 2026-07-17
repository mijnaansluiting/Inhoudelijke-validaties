---
type: Test Subsystem
title: Rule test fixtures
description: Hand-authored passing/failing NLCS++ XML fixtures per rule, run through the compiled rule XSLT in CI.
resource: test/rule_validation_data/v12/
tags: testing
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

There is no unit-test framework (no JUnit/pytest) — rule testing is entirely
data-driven. `test/rule_validation_data/v12/R.<n>/` holds hand-authored
NLCS++ XML fixtures for each rule, split into `passing/` (should produce zero
`assert-failed` elements) and `failing/` (should trigger the rule's assert).
Fixture filenames describe the geometric/data scenario they exercise — e.g.
[R.36](../rules/R.36)'s fixtures include `single_line.xml`, `multi_line.xml`,
`u_turn.xml`, `complex.xml`, and `_offset`/`exact_same_position`/
`ends_at_same_position` variants that specifically probe distance-calculation
edge cases (see [distance-precision-rounding](../decisions/distance-precision-rounding)).

# How fixtures get validated

`scripts/validate_rules.sh` runs every rule's transpiled XSLT (see
[compilation-pipeline](../architecture/compilation-pipeline)) against both
its `passing/` and `failing/` fixture sets, writing SVRL reports to
`rule_validation_reports/v12/<rule>/<passing|failing>/`. `scripts/validate_rule_reports.sh`
then reduces each report to a PASS/FAIL verdict via
`transformations/check_validation_reports.xsl` (PASS = zero asserts for
`passing/`, at least one for `failing/`) and fails CI — posting a
`$GITHUB_STEP_SUMMARY` table of every mismatch — if any fixture doesn't match
its expected outcome. This is wired into the `RuleValidation` workflow, see
[ci/workflows](../ci/workflows).

Before any of this runs, `RuleValidation` also XSD-validates every fixture
against the external Keuzelijst schema via `xerces-cli.jar`, to keep fixtures
themselves well-formed NLCS++.

# Related

[test-visualization](./test-visualization) renders these same
fixtures as SVGs. [coverage-checks](./coverage-checks) verifies
every rule actually has fixtures and that fixtures cover the right object
types.

# Citations

[1] [validate_rules.sh](../../scripts/validate_rules.sh)
[2] [validate_rule_reports.sh](../../scripts/validate_rule_reports.sh)
[3] [test/rule_validation_data/v12/](../../test/rule_validation_data/v12/)
