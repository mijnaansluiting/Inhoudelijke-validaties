---
type: CI/CD Pipeline
title: GitHub Actions workflows
description: The 6 workflows that validate rules/scopes/docs on every PR, check coverage, and publish releases and docs.
resource: .github/workflows/
tags: ci-cd
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

All workflows run on `ubuntu-latest` with JDK 21 Temurin. Most install the
same toolchain (`scripts/install_dependencies.sh` — Saxon-HE, SchXSLT2,
xerces-cli, external NLCS_Netbeheer schemas) before running.

| Workflow | Trigger | Purpose |
|---|---|---|
| `RuleValidation.yml` | PR, push to `main`/`develop` | XSD-validates rule fixtures → [transpiles phases](../architecture/compilation-pipeline) → runs every rule against its [passing/failing fixtures](../testing/rule-test-fixtures) → uploads SVRL reports as a build artifact → checks pass/fail verdicts → [checks object coverage](../testing/coverage-checks). |
| `ScopeValidation.yml` | PR, push to `main`/`develop` | Produces the [scope-checked schema variant](../architecture/compilation-pipeline) → runs [scope-coverage-tests](../testing/scope-coverage-tests) to verify every scope's rule set is exactly right. |
| `DocValidation.yml` | PR/push touching `doc/**` | XSD-validates `doc/NLCSValidatieRegels.xml` itself (`test/XMLValidation.java`) → regenerates and diff-checks the rendered HTML docs and the [test-visualization](../testing/test-visualization) SVGs, failing if either is stale. |
| `RuleCoverage.yml` | PR, push to `main`/`develop` | Lightweight, no toolchain install — cross-checks rule ids between `doc/NLCSValidatieRegels.xml` and `validation_schemas/base/v12.sch` via [coverage-checks](../testing/coverage-checks). |
| `Deliverables.yml` | push of a `v*` tag | Produces the scope-checked schema, runs [build-and-release](../architecture/build-and-release)'s `bundle.sh`, uploads `nlcspp_inhoudelijke_validaties.zip` as a GitHub Release asset. |
| `DeployWithGhPages.yml` | push to `main` | Publishes `doc/NLCSValidatieRegels.html` (plus an `index.html` redirect) to GitHub Pages. |

# Citations

[1] [.github/workflows/](../../.github/workflows/)
