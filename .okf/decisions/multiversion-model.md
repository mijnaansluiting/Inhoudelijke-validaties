---
type: Decision
title: Multiversion model
description: What a rule-set version is, how versions share and override schemas, config, catalog and test data, and how a version is selected at validation time.
tags: decision, versioning, architecture
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-03T00:00:00Z
sources:
  - resource: "https://github.com/mijnaansluiting/Inhoudelijke-validaties/pull/136"
    title: "#136 — setup for multiversion support (v12 -> v2026.1.0 folders)"
  - resource: "../../scripts/install_dependencies.sh"
    title: "install_dependencies.sh (NLCS_NETBEHEER_VERSION)"
  - resource: "../../configuration/sys_config.xml"
    title: "sys_config.xml"
---

# Context

PR #136 moved the Schematron and rule test data from `v12` into
`v2026.1.0` folders, but everything else (scripts, CI, `sys_config.xml`,
the rule catalog, the bundle) still assumes exactly one version. Before
generalizing that, the version model itself had to be decided. The
decisions below were made by the team (interview, 2026-10-27) and are the
contract the implementation steps build on.

# Decision

## What a version is

* A **rule-set version** is a release of the rule set. Any change that
  alters validation outcomes (adding, removing or editing a rule, changing
  a `sys_config` value) produces a new version. It is independent of the
  NLCS_Netbeheer XSD numbering.
* Numbering is `YEAR.RELEASE.FIX`: year, nth release of that year, and
  fixes that don't change intended behavior.
* Version **folders** carry the full version, `vYEAR.RELEASE.FIX` (e.g.
  `v2026.1.0`). There is only ever one folder per `YEAR.RELEASE`: a fix is
  applied in place and the folder is **renamed** (`v2026.1.0` →
  `v2026.1.1`). Later versions' `main.sch` files name older version
  folders in their includes (see below), so a fix rename also rewrites
  every `../../v2026.1.0/` include path in later versions; a rename script
  does this in one pass.
* Rule-set versions map **many-to-one** onto XSD versions: each rule-set
  version targets exactly one XSD version, several may share one
  (`v2026.1.0` → XSD `12.1`).
* **All released versions stay supported** — in the repo, in CI and
  selectable at validation time.

## Repository layout: one root folder per version

Revised 2026-11-02. Version-specific content no longer sits in a version
subfolder of each topic folder (`rules/<version>/`, `doc/<version>/`,
`test/rule_validation_data/<version>/`, …); each version has **one folder
at the repository root** that holds everything belonging to it:

```
<version>/                       e.g. v2026.1.0/, v9999.1.0/
  rules/main.sch                 phases + includes
  rules/patterns/                concrete patterns this version adds/changes
  rules/abstract_patterns/       abstract patterns this version adds
  rules/transpiled_phases/       compiled XSLT (generated, git-ignored)
  rules/abstract_patterns_scope_checks/, rules/main_scope_checks.{sch,xsl}
                                 scope-checked variant (generated, git-ignored)
  doc/NLCSValidatieRegels.{xml,html}   rule catalog + rendered HTML
  test/rule_validation_data/     rule fixtures
  test/scope_validation_data/    scope_template.xml
  assets/                        committed SVGs of the test data
  rule_validation_reports/, validation_test_results/,
  scoped_objects/, scoped_objects_reports/   (generated, git-ignored)
```

Each version folder also holds `xsl_functions/` (the
[XSL function libraries](../architecture/xsl-function-libraries)), unless it
inherits them. Shared, version-independent tooling stays at the root:
`configuration/`, `localization/`, `transformations/`, `wrappers/`,
`scripts/`, `schemas/<xsd version>/`, `doc/NLCSValidatieRegels.{xsl,css,xsd}`
and `test/XMLValidation.java`. Adding, renaming or deleting a version is
one folder operation, and the release `dist/` mirrors this layout so the
relative paths are identical (see
[build-and-release](../architecture/build-and-release)).

## Rule numbering

Rule numbers are never reused. An edited rule keeps its number; a removed
rule's number is retired; a new rule gets the next free number globally.

## Sharing and overriding: explicit includes

Revised 2026-10-28. This replaces two earlier designs: "every later version
inherits from `v2026.1.0` through a `base` attribute", and "a resolve script
combines a version with older versions into a `resolved_<version>` folder".

* **Every version's `main.sch` says exactly which file it uses for each
  rule and abstract pattern.** A version folder only holds its own
  `main.sch` and the files it adds or changes; everything else is included
  by path from the older version folder that has it:

  ```xml
  <include href="../../v2026.1.0/rules/patterns/R.1.sch"/>                  <!-- inherited -->
  <include href="patterns/R.7.sch"/>                                         <!-- own -->
  <include href="../../v2026.1.0/rules/abstract_patterns/geometrie/x.sch"/>  <!-- inherited -->
  <include href="../../v2026.2.0/rules/abstract_patterns/geometrie/y.sch"/>  <!-- own -->
  ```

  **Abstract-pattern includes always name a version folder**, also for the
  version's own files (`../../v2026.2.0/rules/abstract_patterns/…`, never
  `abstract_patterns/…`), so every abstract pattern's origin is explicit.
  Concrete-pattern includes of the version's own files may stay relative
  (`patterns/R.7.sch`).

  This works without any build step because concrete patterns include
  nothing themselves: `main.sch` includes both concrete and abstract
  patterns directly, and concrete patterns refer to abstract ones by id
  (`is-a`). SchXslt follows the paths while transpiling. The function
  libraries are included as `../../xsl_functions/…` (own) or
  `../../../<older version>/xsl_functions/…` (inherited); SchXslt copies that
  path into the compiled XSL unchanged, so all compiled output of a version
  lives in `<version>/rules/transpiled_phases/`, where it resolves.
  `scripts/versions.sh rules` finds a rule's source version by parsing
  includes matching `(../../v*/rules/)?patterns/R.*`.
* **Allowed include targets:** the version itself, or an **older,
  released** version. Never a newer or an unreleased version, so a
  half-finished version never leaks into a real one.
* **A rule is taken whole:** all pattern files of a rule (`R.4_A` + `R.4_B`)
  come from one version, and the rule's test data comes from the same
  version folder as its patterns. A version that has its own pattern for a
  rule must also have that rule's test data.
* **Editing a rule** = copy its pattern file(s) and its test data folder
  into the version, change both, and point the includes at the version's
  own files. **Adding a rule** = new pattern, test data, phase, include and
  catalog entry. **Removing a rule** = delete its `<phase>` and its
  `<include>` line(s) from the version's `main.sch` and its catalog entry;
  no files are deleted.
* **Files of older versions never get behavior changes.** A behavior change
  always goes into the version folder as an override. Older files may
  receive fixes, and later versions that include them **inherit** those
  fixes. If a later version must not inherit a fix, it overrides the file
  first.
* **Abstract patterns are not overridden.** When a version needs different
  abstract-pattern behavior, a *new* abstract pattern (new id/file) is
  added and the version's overriding concrete pattern uses it; the old one
  stays untouched.
* The registry has **no `base` attribute**: which version a rule comes from
  is visible in each `main.sch`, not derived from version order.
* **XSL function libraries are versioned** (revised 2026-11-02; they were
  a single shared copy at the root that had to stay backwards compatible).
  They live in `<version>/xsl_functions/` and are inherited like patterns:
  a version includes an older version's library until it needs different
  behavior, then gets its own copy of that library. Currently only
  `v2026.1.0/xsl_functions/` exists; `v9999.1.0` inherits all of it.
* **Bugs found in a rule present in several versions** are handled case by
  case; the decision is recorded in the PR.

## Version-specific data

| Item | Model |
|---|---|
| Rule catalog (`NLCSValidatieRegels.xml`) | One full file per version: `vX/doc/NLCSValidatieRegels.xml`, each generating its own `vX/doc/NLCSValidatieRegels.html`. The stylesheet, CSS and XSD in the root `doc/` are shared. |
| `sys_config.xml` | One full block per version (`<version id="v2026.1.0">…</version>`) holding every value; no defaults/inheritance. |
| `localization/messages.xml` | Shared. Changed text for a rule = a new message id used by the overriding pattern; old ids remain for older versions. |
| `user_config.xml` | Shared. |
| Rule test data (`vX/test/rule_validation_data`) | Follows `main.sch`: a rule's fixtures are taken from the version folder its pattern is included from. A version folder only holds fixtures for rules it added or changed. Rules not in `main.sch` are not run. |
| Scope test data (`vX/test/scope_validation_data`) | One `scope_template.xml` per version, copied when the version is created. |
| XSD | Downloaded per targeted XSD version into `schemas/<xsd version>/`. |
| Test-data SVGs (`assets`) | Per version: `vX/assets/`, generated by `generate_and_compare_svgs.sh`. |

## Version selection at validation time

* By default the version is **detected from the file**: the NLCS++ version
  in the `VersieNummer` attribute of the root `<NLCSnetbeheer>` (e.g.
  `VersieNummer="12.1"`) selects the **newest released rule-set version
  whose `nlcspp` equals it**. `xsi:schemaLocation` is not used. (Revised
  2026-10-29; detection used `xsi:schemaLocation` before.)
* An optional **`version` parameter** selects any supported version
  explicitly; this is how older versions sharing an XSD stay reachable.
  It accepts both a full id (`v2026.1.0`) and a `vYEAR.RELEASE` alias
  (`v2026.1`) meaning the newest fix of that release. Callers that pin the
  alias keep working when a fix renames the folder; a pinned full id stops
  resolving once that fix is renamed away.
* If `VersieNummer` is missing (it is optional in the XSD) or not targeted
  by any released version, validation **fails with an explicit error**
  ("unsupported NLCS version") rather than falling back.
* Every test XML declares `VersieNummer` equal to its version's `nlcspp`;
  `scripts/validate_test_data_xsd.sh` checks this per version.
* The selection is implemented by the
  [version-dispatcher](../architecture/version-dispatcher) `validate.xsl`
  (2026-11-03), which runs the selected version's compiled schema with
  `fn:transform()` and stops with error `ma:unsupported-version`.

## CI

CI runs **every supported version on every PR**, as a matrix with one job
per version, because a fix to an older version's file and shared edits can
affect all versions that include it.

Because includes are written by hand, CI also checks every version's
`main.sch`:

* every include points to an existing file;
* every phase has its pattern include(s) and every pattern include has a
  phase;
* includes only point to the version itself or older released versions;
* all pattern files of a rule come from one version, and a version with
  its own pattern for a rule also has that rule's test data;
* `active_version` equals the folder name (already checked by
  `scripts/check_active_version.sh`).

## Testing the model

A fictional `v2026.2.0` (unreleased) is created from `v2026.1.0` that adds
one rule, removes one rule and edits one rule, to prove isolation and
inheritance end to end. It is deleted once the infrastructure is proven
and is never shipped. The `released` attribute itself is expected to be
dropped eventually; the "only older released versions" include rule then
becomes "only older versions".

# Release packaging

Decided 2026-11-03: **one zip** with every released version and the
dispatcher; see [build-and-release](../architecture/build-and-release).

The version registry format was settled as XML; see
[version-registry](../config/version-registry). The remaining
implementation steps are in [multiversion-plan](../architecture/multiversion-plan).
