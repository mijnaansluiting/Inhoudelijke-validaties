---
type: Test Subsystem
title: Rule test fixtures
description: Hand-authored passing/failing NLCS++ XML fixtures per rule, run through the compiled rule XSLT in CI.
resource: v2026.1.0/test/rule_validation_data/
tags: testing
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../scripts/validate_rules.sh"
    title: "validate_rules.sh"
  - resource: "../../scripts/validate_rule_reports.sh"
    title: "validate_rule_reports.sh"
  - resource: "../../v2026.1.0/test/rule_validation_data/"
    title: "v2026.1.0/test/rule_validation_data/"
---

# Overview

There is no unit-test framework (no JUnit/pytest) — rule testing is entirely
data-driven. `<version>/test/rule_validation_data/R.<n>/` (e.g.
`v2026.1.0/test/rule_validation_data/R.36/`) holds hand-authored NLCS++ XML
fixtures for each rule a version adds or changes; a rule's fixtures are taken
from the version folder its pattern is included from (`scripts/versions.sh
rules`, see [multiversion-model](../decisions/multiversion-model)).
Fixtures are split into `passing/` (should produce zero `assert-failed`
elements) and `failing/` (should trigger the rule's assert).
Fixture filenames describe the geometric/data scenario they exercise — e.g.
[R.36](../rules/R.36)'s fixtures include `single_line.xml`, `multi_line.xml`,
`u_turn.xml`, `complex.xml`, and `_offset`/`exact_same_position`/
`ends_at_same_position` variants that specifically probe distance-calculation
edge cases (see [distance-precision-rounding](../decisions/distance-precision-rounding)).

# How fixtures get validated

`scripts/validate_rules.sh` runs every rule's transpiled XSLT (see
[compilation-pipeline](../architecture/compilation-pipeline)) against both
its `passing/` and `failing/` fixture sets, writing SVRL reports to
`<version>/rule_validation_reports/<rule>/<passing|failing>/` (git-ignored).
`scripts/validate_rule_reports.sh`
then reduces each report to a PASS/FAIL verdict via
`transformations/check_validation_reports.xsl` into
`<version>/validation_test_results/` (PASS = zero asserts for
`passing/`, at least one for `failing/`) and fails CI — posting a
`$GITHUB_STEP_SUMMARY` table of every mismatch — if any fixture doesn't match
its expected outcome. This is wired into the `validate-rules` job of the
`CI` workflow, see
[ci/workflows](../ci/workflows).

Before any of this runs, `validate-rules` also XSD-validates every fixture
against its version's Keuzelijst schema (`schemas/<xsd version>/`) via
`xerces-cli.jar` (`scripts/validate_test_data_xsd.sh`), to keep fixtures
themselves well-formed NLCS++.

# Related

[test-visualization](./test-visualization) renders these same
fixtures as SVGs. [coverage-checks](./coverage-checks) verifies
every rule actually has fixtures and that fixtures cover the right object
types.
