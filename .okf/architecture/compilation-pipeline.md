---
type: Architecture Component
title: Compilation and execution pipeline
description: How a Schematron rule becomes runnable XSLT and produces an SVRL validation report.
resource: scripts/transpile_phases.sh
tags: architecture, build
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../scripts/transpile_phases.sh"
    title: "transpile_phases.sh"
  - resource: "../../wrappers/transpile_phase_wrapper.xsl"
    title: "transpile_phase_wrapper.xsl"
  - resource: "../../scripts/validate_rules.sh"
    title: "validate_rules.sh"
---

# Overview

There is no persistent validation service — this repo is a toolchain that
compiles [Schematron rules](./schematron-layering) into
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
   a version's `validation_schemas/<version>/main.sch`, producing one
   standalone `.xsl` stylesheet per rule in
   `validation_schemas/<version>/transpiled_phases/<rule>.xsl` (git-ignored):

   ```bash
   java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl \
     -s:validation_schemas/v2026.1.0/main.sch \
     -o:validation_schemas/v2026.1.0/transpiled_phases/R.36.xsl phase=R.36
   ```

   SchXslt copies `main.sch`'s `<xsl:include href="../../xsl_functions/…"/>`
   lines unchanged into every compiled file, and Saxon resolves them from
   the compiled file's own location. So **every** stylesheet compiled from a
   `main.sch` lives exactly two folders below `validation_schemas/`, in
   `transpiled_phases/`: the per-rule phases and the scope-checked
   `main_scope_checks.xsl` alike. A compiled file anywhere else cannot find
   the function libraries.

3. **Execution** — running that generated XSLT via Saxon against an NLCS++
   XML instance produces an **SVRL** report (Schematron Validation Report
   Language) listing `<successful-report>`/`<assert-failed>` elements
   annotated with the `scope`/`severity`/`object-type` properties from
   [schematron-layering](./schematron-layering).
   `scripts/validate_rules.sh` does this for every rule against its
   [test fixtures](../testing/rule-test-fixtures), and
   `transformations/check_validation_reports.xsl` reduces a report to a
   PASS/FAIL verdict by counting `<assert-failed>` elements.

4. **Scope-checked variant** — `scripts/add_scope_checks.sh` runs
   `transformations/abstract_patterns_scope_checks.xsl` and
   `transformations/base_scope_checks.xsl` to produce a rewritten schema
   (`validation_schemas/abstract_patterns_scope_checks/`,
   `validation_schemas/base_scope_checks/v12.sch`) whose abstract patterns
   additionally assert that each object falls within its expected scope —
   this variant is what [scope-coverage-tests](../testing/scope-coverage-tests)
   and the release bundle ([build-and-release](./build-and-release))
   use, not the plain rule logic.

This whole pipeline exists so that a "phase" (= one rule) can be compiled and
run in isolation, which is what makes per-rule pass/fail testing in CI
tractable — see [rule-test-fixtures](../testing/rule-test-fixtures).
