---
type: CI/CD Pipeline
title: GitHub Actions workflows
description: The 3 workflows — CI (rules/scopes/docs/coverage on every PR), Deliverables (release zip) and GitHub Pages (rule catalog).
resource: .github/workflows/
tags: ci-cd
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../.github/workflows/"
    title: ".github/workflows/"
---

# Overview

There are three workflows. The jobs run on `ubuntu-latest` with JDK 21
Temurin. Every version-dependent step takes the version explicitly, today
always `$(scripts/versions.sh latest)` (see
[version-registry](../config/version-registry)); paths are the per-version
root folders of [multiversion-model](../decisions/multiversion-model)
(`<version>/rules/`, `<version>/doc/`, …).

| Workflow | Trigger | Purpose |
|---|---|---|
| `CI.yml` | PR, push to `main`/`develop` | Jobs in order (each needs the previous): **`covered-rules`** — no toolchain; cross-checks rule ids between `<version>/doc/NLCSValidatieRegels.xml` and `<version>/rules/main.sch` via [coverage-checks](../testing/coverage-checks), and runs `check_active_version.sh`. **`install-dependencies`** — `scripts/install_dependencies.sh` once (Saxon-HE, SchXSLT2, xerces-cli, `schemas/<xsd>/`), shared with later jobs as an artifact. **`validate-rules`** — XSD-validates rule fixtures → [transpiles phases](../architecture/compilation-pipeline) into `<version>/rules/transpiled_phases/` → runs every rule against its [passing/failing fixtures](../testing/rule-test-fixtures) → uploads `v*/rule_validation_reports` as the `rule-validation-reports` artifact → checks pass/fail verdicts → [checks object coverage](../testing/coverage-checks). **`validate-scopes`** — `add_scope_checks.sh`, transpiles `-s:$version/rules/main_scope_checks.sch -o:$version/rules/transpiled_phases/main_scope_checks.xsl`, then runs [scope-coverage-tests](../testing/scope-coverage-tests). **`validate-docs`** — XSD-validates `$version/doc/NLCSValidatieRegels.xml` against the shared `doc/NLCSValidatieRegels.xsd` (`test/XMLValidation.java`) → regenerates and diff-checks `$version/doc/NLCSValidatieRegels.html` and the [test-visualization](../testing/test-visualization) SVGs in `$version/assets/`, failing if either is stale. |
| `Deliverables.yml` | push of a `v*` tag | Produces the scope-checked schema (same transpile step as `validate-scopes`), runs [build-and-release](../architecture/build-and-release)'s `bundle.sh`, uploads `dist/` as an artifact and `nlcspp_inhoudelijke_validaties.zip` as a GitHub Release asset. |
| `DeployWithGhPages.yml` | push to `main` | Publishes the repository to GitHub Pages with an `index.html` that redirects to `<latest>/doc/NLCSValidatieRegels.html`. |
