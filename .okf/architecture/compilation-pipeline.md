---
type: Architecture Component
title: Compilation and execution pipeline
description: How a Schematron rule becomes runnable XSLT and produces an SVRL validation report.
resource: scripts/transpile_phases.sh
tags: architecture, build
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

There is no persistent validation service — this repo is a toolchain that
compiles [Schematron rules](/architecture/schematron-layering.md) into
standalone XSLT, which is then run directly against an NLCS++ XML instance.
The pipeline, driven by bash scripts and **Saxon-HE** (Java, XSLT/XPath 3.0)
plus **SchXSLT2** (a Schematron→XSLT transpiler):

1. **Dependency install** (`scripts/install_dependencies.sh`) — downloads
   Saxon-HE, SchXSLT2's `transpile.xsl`, a custom `xerces-cli.jar` (XSD
   validation), and the external `NLCS_Netbeheer.xsd` /
   `NLCS_Netbeheer<provider>Import_Keuzelijst.xsd` schemas that define the
   NLCS++ input format itself, from `schemas.mijnaansluiting.nl`. None of
   these are vendored — they're fetched fresh on every run.

2. **Per-phase transpilation** (`scripts/transpile_phases.sh`) — for every
   rule (a Schematron "phase"), runs SchXSLT2's `transpile.xsl` (wrapped by
   `wrappers/transpile_phase_wrapper.xsl`, which works around Saxon CLI not
   accepting namespaced `schxslt:phase` parameters) against
   `validation_schemas/base/v12.sch`, producing one standalone `.xsl`
   stylesheet per rule under `validation_schemas/phases_transpiled/`:

   ```bash
   java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl \
     -s:validation_schemas/base/v12.sch \
     -o:validation_schemas/phases_transpiled/R.36.xsl phase=R.36
   ```

3. **Execution** — running that generated XSLT via Saxon against an NLCS++
   XML instance produces an **SVRL** report (Schematron Validation Report
   Language) listing `<successful-report>`/`<assert-failed>` elements
   annotated with the `scope`/`severity`/`object-type` properties from
   [schematron-layering](/architecture/schematron-layering.md).
   `scripts/validate_rules.sh` does this for every rule against its
   [test fixtures](/testing/rule-test-fixtures.md), and
   `transformations/check_validation_reports.xsl` reduces a report to a
   PASS/FAIL verdict by counting `<assert-failed>` elements.

4. **Scope-checked variant** — `scripts/add_scope_checks.sh` runs
   `transformations/abstract_patterns_scope_checks.xsl` and
   `transformations/base_scope_checks.xsl` to produce a rewritten schema
   (`validation_schemas/abstract_patterns_scope_checks/`,
   `validation_schemas/base_scope_checks/v12.sch`) whose abstract patterns
   additionally assert that each object falls within its expected scope —
   this variant is what [scope-coverage-tests](/testing/scope-coverage-tests.md)
   and the release bundle ([build-and-release](/architecture/build-and-release.md))
   use, not the plain rule logic.

This whole pipeline exists so that a "phase" (= one rule) can be compiled and
run in isolation, which is what makes per-rule pass/fail testing in CI
tractable — see [rule-test-fixtures](/testing/rule-test-fixtures.md).

# Citations

[1] [transpile_phases.sh](../../scripts/transpile_phases.sh)
[2] [transpile_phase_wrapper.xsl](../../wrappers/transpile_phase_wrapper.xsl)
[3] [validate_rules.sh](../../scripts/validate_rules.sh)
