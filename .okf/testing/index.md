# Testing

How rules, scope coverage, and documentation freshness are verified — all
data-driven, no unit-test framework.

* [Rule test fixtures](rule-test-fixtures.md) - Hand-authored passing/failing NLCS++ XML fixtures per rule, run through the compiled rule XSLT in CI.
* [Test data visualization](test-visualization.md) - Auto-generated SVG renderings of every rule fixture's geometry, committed to assets/ for the wiki.
* [Scope coverage tests](scope-coverage-tests.md) - A meta-test verifying the scope/severity engine itself assigns exactly the right rules to every scope, with no gaps or overlaps.
* [Rule and object coverage checks](coverage-checks.md) - Lightweight cross-checks that every documented rule is implemented, and that a rule's asserts touch the object types it claims to.
