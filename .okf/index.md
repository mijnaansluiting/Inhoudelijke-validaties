---
okf_version: "0.1"
---

# Inhoudelijke Validaties — Knowledge Bundle

This bundle documents the NLCS++ content-validation rule set: what each rule
checks, how severity varies by scope, how rules are compiled/tested/released,
and the "why" behind a few non-obvious past fixes. Ground truth for rule
content is `doc/NLCSValidatieRegels.xml`; this bundle exists to make that
XML, plus the surrounding Schematron/XSLT implementation and CI tooling,
quickly answerable without re-deriving it from source each time.

# Start here

* [Domain](domain/index.md) - What NLCS++ is, and the scope/severity model that governs rule enforcement.
* [Rules](rules/index.md) - All 37 validation rules (R.1–R.41), grouped by category.

# Reference

* [Architecture](architecture/index.md) - Schematron layering, XSL function libraries, the compile/run pipeline, and the release build.
* [Configuration](config/index.md) - sys_config.xml, user_config.xml, and the localization message catalog.
* [Testing](testing/index.md) - Rule fixtures, test-data visualization, and scope/rule coverage checks.
* [CI/CD](ci/index.md) - The GitHub Actions workflows that enforce all of the above.
* [Decisions](decisions/index.md) - Tacit "why" behind past fixes, recovered from git history.
