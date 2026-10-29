---
type: Plan
title: Multiversion implementation plan
description: Ordered steps to make scripts, CI and the release support several rule-set versions, with what is done and what remains.
tags: versioning, plan, ci
status: draft
generated:
  by: claude-opus-5-5
  at: 2026-10-28T00:00:00Z
sources:
  - resource: "../decisions/multiversion-model.md"
    title: "Multiversion model"
---

# Overview

Implementation order for the [multiversion-model](../decisions/multiversion-model),
first to last. Each step must leave the results for `v2026.1.0` unchanged;
the fictional `v2026.2.0` (step 7) is the first test with a second version.

# Done

1. **Version model decided** — [multiversion-model](../decisions/multiversion-model).
2. **Version registry** — `configuration/versions.xml` and
   `scripts/versions.sh` (see [version-registry](../config/version-registry));
   scripts and workflows read the version from it.
3. **Per-version config and catalog** — `sys_config.xml` block per version,
   selected through `$active_version` in each `main.sch`; catalog in
   `doc/<version>/`; `scripts/check_active_version.sh` in CI.
4. **XSD per version** — `xsd/<xsd version>/`, test data checked against
   its own version's XSD and `VersieNummer` (= the version's `nlcspp`) by
   `scripts/validate_test_data_xsd.sh`.

# Step 5: run the pipeline per version

1. **Fix the scope-validation crash.** All objects in
   `scope_template.xml` share ID `0000`, which makes the `<map>` in
   `connectivity_functions.xsl` fail with "Duplicate key"; build it with
   `map:merge` and `'duplicates': 'combine'`. Make `validate_scopes.sh` fail
   when Saxon fails or a report is empty.
2. **`main.sch` include checks** (new script, CI `covered-rules` job): every
   include exists; phases and pattern includes match; includes only point to
   the version itself or older released versions; a rule's pattern files
   come from one version; a version with its own pattern for a rule has
   that rule's test data.
3. **Rule-source helper**: reads a version's `main.sch` and prints, per
   phase, the version folder its pattern is included from. A rule's test
   data comes from `test/rule_validation_data/<that version>/R.x/`.
4. **Scripts per version**, using the helper:
   * `transpile_phases.sh` loops over the phases in `main.sch` (not over
     test data folders) and writes to `validation_schemas/phases_transpiled_<version>/`
     — directly under `validation_schemas/`, because the transpiled XSL
     keeps the relative `../xsl_functions/` includes;
   * `validate_rules.sh`, `validate_rule_reports.sh` (report links point to
     the fixture's real folder), `check_rule_object_coverage.sh` read
     fixtures through the helper;
   * `add_scope_checks.sh` runs for **every** version folder before any
     scope schema is transpiled, because `../vX/abstract_patterns/…`
     includes become `../vX/abstract_patterns_scope_checks/…`;
   * `validate_scopes.sh` writes to `scoped_objects/<version>/` and
     `scoped_objects_reports/<version>/`;
   * `generate_and_compare_svgs.sh` writes `assets/<version>/` for each
     version's own fixtures (one-time move of the current SVGs to
     `assets/v2026.1.0/`).
5. **CI matrix**: a first job outputs `scripts/versions.sh matrix`; the
   rule, scope and docs jobs run per version (`fail-fast: false`) with the
   version in every artifact name. `install-dependencies` stays a single
   job.
6. **Verify**: every result for `v2026.1.0` is identical to before.

# Step 6: version scripts

* `scripts/new_version.sh <new> <xsd>`: registry entry (`released="false"`);
  copy the previous version's `main.sch`, turning its own relative includes
  (`patterns/…`, `abstract_patterns/…`) into `../<previous>/…` and keeping
  existing `../vX/` includes; set `active_version`; empty `patterns/`,
  `abstract_patterns/` and test data folders; copy the scope template,
  catalog and `sys_config` block.
* `scripts/rename_version.sh <old> <new>` for fix renames: rename the
  folders under `validation_schemas/`, `test/` and `doc/`, the `sys_config`
  id, the registry entry and `active_version`, and rewrite every
  `../<old>/` include in later versions' `main.sch`.

# Step 7: fictional version

Create `v2026.2.0` (unreleased) with `new_version.sh`: add one rule, remove
one rule, edit one rule. CI must pass for both versions, and `v2026.1.0`'s
results must not change.

# Step 8: selection and release

* Validation-time version selection: wire `version_functions.xsl`
  (`ma:select-version`) into a dispatcher that picks the version from
  the root's `VersieNummer` or the optional `version` parameter, and fails on
  an unsupported XSD version.
* Release packaging (one zip, a zip per version, or both): still open.

# Step 9: clean up

* Delete the fictional `v2026.2.0`.
* Update the OKF pages that still describe `v12` paths (rules, testing, CI,
  schematron-layering, compilation-pipeline).
