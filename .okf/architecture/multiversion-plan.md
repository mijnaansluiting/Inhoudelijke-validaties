---
type: Plan
title: Multiversion implementation plan
description: Ordered steps to make scripts, CI and the release support several NLCS++ versions, with what is done and what remains.
tags: versioning, plan, ci
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-10T00:00:00Z
sources:
  - resource: "../decisions/multiversion-model.md"
    title: "Multiversion model"
---

# Overview

Implementation order for the [multiversion-model](../decisions/multiversion-model),
first to last. Each step must leave the results for `v12.1` (the released
rule set, formerly `v2026.1.0`) unchanged. Since 2026-11-05 a version is an
NLCS++ version. `v12` held the fictional test changes of the former
`v9999.1.0` until it was removed on 2026-11-10; `v12.1` is now the only
version.

# Done

1. **Version model decided** — [multiversion-model](../decisions/multiversion-model).
2. **Version registry** — `configuration/versions.xml` and
   `scripts/versions.sh` (see [version-registry](../config/version-registry));
   scripts and workflows read the version from it.
3. **Per-version config and catalog** — `sys_config.xml` block per version,
   selected through `$active_version` in each `main.sch`; catalog in
   `<version>/doc/`; `scripts/check_active_version.sh` in CI.
4. **XSD per version** — `schemas/<xsd version>/`, test data checked against
   its own version's XSD and `VersieNummer` (= the version id without `v`) by
   `scripts/validate_test_data_xsd.sh`.
5. **Folders per NLCS++ version** (2026-11-05) — `v2026.1.0` → `v12.1`,
   `v9999.1.0` → `v12`, inheritance flipped so `v12.1` includes from `v12`;
   registry reduced to `id`, `released` flag dropped; rule validation
   reports byte-identical to before. See
   [multiversion-model](../decisions/multiversion-model).
6. **`v12` removed** (2026-11-10) — everything `v12.1` inherited from it
   (patterns, abstract patterns, fixtures, SVGs, `xsl_functions/`) moved
   into `v12.1/`; `v12`'s registry entry and `sys_config` block removed;
   every rule's `laatstGewijzigd` is `v12.1`. This also settled step 5.7
   and the step 9 decision below.

**Repository layout: one folder per version at the root.** Everything
version-specific lives under `<version>/` (e.g. `v12.1/`):
`rules/` (`main.sch`, `patterns/`, `abstract_patterns/` and the generated
`transpiled_phases/`, `abstract_patterns_scope_checks/`,
`main_scope_checks.{sch,xsl}`), `doc/NLCSValidatieRegels.{xml,html}`,
`test/rule_validation_data/`, `test/scope_validation_data/`, `assets/`
(committed test-data SVGs) and the generated `rule_validation_reports/`,
`validation_test_results/`, `scoped_objects/` and `scoped_objects_reports/`.
Function libraries are versioned as `<version>/xsl_functions/` (inherited
like patterns). Shared tooling stays at the root: `configuration/`,
`localization/`, `transformations/`, `wrappers/`, `scripts/`, `schemas/`,
and `doc/NLCSValidatieRegels.{xsl,css,xsd}`. The release `dist/` mirrors
this layout (see [build-and-release](./build-and-release)).

# Step 5: run the pipeline per version

1. **Fix the scope-validation crash.** All objects in
   `scope_template.xml` share ID `0000`, which makes the `<map>` in
   `connectivity_functions.xsl` fail with "Duplicate key"; build it with
   `map:merge` and `'duplicates': 'combine'`. Make `validate_scopes.sh` fail
   when Saxon fails or a report is empty.
2. **`main.sch` include checks** (new script, CI `covered-rules` job): every
   include exists; phases and pattern includes match; includes only point to
   the version itself or older versions; a rule's pattern files
   come from one version; a version with its own pattern for a rule has
   that rule's test data.
3. **Rule-source helper**: reads a version's `main.sch` and prints, per
   phase, the version folder its pattern is included from. A rule's test
   data comes from `<that version>/test/rule_validation_data/R.x/`
   (`scripts/versions.sh rules`).
4. **Scripts per version**, using the helper:
   * `transpile_phases.sh` loops over the phases in `main.sch` (not over
     test data folders) and writes to
     `<version>/rules/transpiled_phases/<rule>.xsl`, the same
     folder as the compiled `main_scope_checks.xsl` (`main.sch` includes
     `../../xsl_functions/` or `../../../<older version>/xsl_functions/`,
     which only resolve from there);
   * `validate_rules.sh`, `validate_rule_reports.sh` (report links point to
     the fixture's real folder), `check_rule_object_coverage.sh` read
     fixtures through the helper;
   * `add_scope_checks.sh` runs for **every** version folder before any
     scope schema is transpiled, because `../../vX/rules/abstract_patterns/…`
     includes become `../../vX/rules/abstract_patterns_scope_checks/…`;
   * `validate_scopes.sh` writes to `<version>/scoped_objects/` and
     `<version>/scoped_objects_reports/`;
   * `generate_and_compare_svgs.sh` writes `<version>/assets/` for each
     version's own fixtures (the current SVGs live in
     `v12.1/assets/`).
5. **CI matrix**: a first job outputs `scripts/versions.sh matrix`; the
   rule, scope and docs jobs run per version (`fail-fast: false`) with the
   version in every artifact name. `install-dependencies` stays a single
   job.
6. **Verify**: every result for `v12.1` is identical to before.
7. ~~**Make the `v12` test data pass the XSD check.**~~ Resolved by removing
   `v12` (2026-11-10): the inherited fixtures, which were 12.1 data checked
   against XSD 12, now live in `v12.1`, and `validate_test_data_xsd.sh v12.1`
   passes.

# Step 6: version scripts

* `scripts/new_version.sh <new>` (e.g. `v13`): registry entry;
  copy the previous version's `main.sch`, turning its own relative pattern
  includes (`patterns/…`) into `../../<previous>/rules/patterns/…` and keeping
  existing `../../vX/rules/` includes (abstract-pattern includes already always name
  a version folder); set `active_version`; empty `patterns/`,
  `abstract_patterns/` and test data folders; copy the scope template,
  catalog and `sys_config` block, all under the new `<new>/` root folder.
* ~~`scripts/rename_version.sh`~~ — no longer needed: fixes are made in
  place and folders are never renamed (2026-11-05).

# Step 7: fictional version

Done differently: `v12` (formerly `v9999.1.0`) added `R.44`, removed `R.13`
and edited `R.15` compared to `v12.1`. It was removed on 2026-11-10 without
ever passing CI (step 5.7), so inheritance between versions is untested
until the next real NLCS++ version is added.

# Step 8: selection and release

* Validation-time version selection: wire `version_functions.xsl`
  (`ma:select-version`) into a dispatcher that picks the version from
  the root's `VersieNummer` or the optional `version` parameter, and fails on
  an unsupported XSD version.
* ~~Release packaging~~ — decided 2026-11-04: one zip with every version
  (see [build-and-release](./build-and-release)).

# Step 9: clean up

* ~~Decide what happens to the fictional rule changes in `v12`~~ —
  decided 2026-11-10: `v12` was removed; its `R.44` and `R.15` override
  were dropped.
* ~~Update the OKF pages that still describe `v12` paths~~ — done
  2026-11-02 together with the per-version root restructure.
