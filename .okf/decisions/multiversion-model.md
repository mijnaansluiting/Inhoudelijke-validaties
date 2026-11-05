---
type: Decision
title: Multiversion model
description: What a version (an NLCS++ version) is, how versions share and override schemas, config, catalog and test data, and how a version is selected at validation time.
tags: decision, versioning, architecture
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-05T00:00:00Z
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
the rule catalog, the bundle) still assumed exactly one version. Before
generalizing that, the version model itself had to be decided. The
decisions below were made by the team (interview, 2026-10-27) and are the
contract the implementation steps build on.

Revised 2026-11-05: versions were software releases (`vYEAR.RELEASE.FIX`
folders such as `v2026.1.0`, renamed on every fix). They are now **NLCS++
versions**: one set of rules per NLCS++ version. `v2026.1.0` became `v12.1`;
the fictional test version `v9999.1.0` became `v12`, and the inheritance
direction was flipped so that the newer `v12.1` includes from the older
`v12` (see "Restructure of 2026-11-05" below).

# Decision

## What a version is

* A **version** is an **NLCS++ version** (the NLCS_Netbeheer XSD version):
  there is one set of rules per NLCS++ version. The mapping onto XSD
  versions is **one-to-one**.
* Version **folders** are named `v` + the NLCS++ version: `v12/`, `v12.1/`.
  The same id is used in the registry, in `sys_config.xml` and as
  `active_version` in `main.sch`.
* **Rule changes within an NLCS++ version are made in place**, in that
  version's folder (or, for an inherited file, by overriding it first; see
  below). The software release number exists only as the `v*` git tag and
  the GitHub Release (see [build-and-release](../architecture/build-and-release));
  no folder, registry entry or parameter carries it.
* **All versions are supported** — in the repo, in CI, shipped in the
  release and selectable at validation time. There is no `released` flag.

## Repository layout: one root folder per version

Revised 2026-11-02. Version-specific content no longer sits in a version
subfolder of each topic folder (`rules/<version>/`, `doc/<version>/`,
`test/rule_validation_data/<version>/`, …); each version has **one folder
at the repository root** that holds everything belonging to it:

```
<version>/                       e.g. v12/, v12.1/
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
and `test/XMLValidation.java`. Adding or deleting a version is one folder
operation, and the release `dist/` mirrors this layout so the relative paths
are identical (see [build-and-release](../architecture/build-and-release)).

## Rule numbering

Rule numbers are never reused. An edited rule keeps its number; a removed
rule's number is retired; a new rule gets the next free number globally.

## Sharing and overriding: explicit includes

Revised 2026-10-28. This replaces two earlier designs: "every later version
inherits from a base version through a `base` attribute", and "a resolve
script combines a version with older versions into a `resolved_<version>`
folder".

* **Every version's `main.sch` says exactly which file it uses for each
  rule and abstract pattern.** A version folder only holds its own
  `main.sch` and the files it adds or changes; everything else is included
  by path from the older version folder that has it:

  ```xml
  <include href="../../v12/rules/patterns/R.1.sch"/>                    <!-- inherited -->
  <include href="patterns/R.13.sch"/>                                    <!-- own -->
  <include href="../../v12/rules/abstract_patterns/geometrie/x.sch"/>   <!-- inherited -->
  <include href="../../v12.1/rules/abstract_patterns/geometrie/y.sch"/> <!-- own -->
  ```

  **Abstract-pattern includes always name a version folder**, also for the
  version's own files (`../../v12.1/rules/abstract_patterns/…`, never
  `abstract_patterns/…`), so every abstract pattern's origin is explicit.
  Concrete-pattern includes of the version's own files may stay relative
  (`patterns/R.13.sch`).

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
* **Allowed include targets:** the version itself, or an **older** NLCS++
  version. Never a newer one.
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
* **A change to an older version's file is inherited** by every newer
  version that includes it. Changes to one NLCS++ version that must not reach
  newer versions go into an override in the newer version first.
* **Abstract patterns are not overridden.** When a version needs different
  abstract-pattern behavior, a *new* abstract pattern (new id/file) is
  added and the version's overriding concrete pattern uses it; the old one
  stays untouched. An abstract pattern lives in the oldest version that
  uses it.
* The registry has **no `base` attribute**: which version a rule comes from
  is visible in each `main.sch`, not derived from version order.
* **XSL function libraries are versioned** (revised 2026-11-02; they were
  a single shared copy at the root that had to stay backwards compatible).
  They live in `<version>/xsl_functions/` and are inherited like patterns:
  a version includes an older version's library until it needs different
  behavior, then gets its own copy of that library. Currently only
  `v12/xsl_functions/` exists; `v12.1` inherits all of it.
* **Bugs found in a rule present in several versions** are handled case by
  case; the decision is recorded in the PR.

## Restructure of 2026-11-05

The software-release folders were mapped onto NLCS++ versions as follows,
with every rule result unchanged (the rule validation reports of `v12.1` and
`v12` are byte-identical to those of `v2026.1.0` and `v9999.1.0`):

| Now | Was | Holds |
|---|---|---|
| `v12` | `v9999.1.0` (XSD 12, unreleased test version) | Every shared pattern, abstract pattern, fixture, SVG and the XSL function libraries, which used to live in `v2026.1.0`; plus its own `R.15` (overridden) and `R.44` (added) with their abstract patterns `verplichte_kenmerken_mantelbuis_eigenaar` and `verplichte_kenmerken_kunstwerk`. `R.13` is not in its `main.sch`. |
| `v12.1` | `v2026.1.0` (XSD 12.1, released) | Its own `R.13` and original `R.15` (patterns and fixtures) and the abstract patterns only they use (`verplichte_kenmerken_msoverdrachtspunt`, `verplichte_kenmerken_mantelbuis`); includes everything else from `v12`. |

Consequence: the fixtures of the inherited rules now live in `v12` and are
XSD-checked against XSD 12 with `VersieNummer="12"`. They are 12.1 data, so
`validate_test_data_xsd.sh v12` fails until the test data or the version
detection for XSD 12 is fixed (see
[multiversion-plan](../architecture/multiversion-plan)).

## Version-specific data

| Item | Model |
|---|---|
| Rule catalog (`NLCSValidatieRegels.xml`) | One full file per version: `vX/doc/NLCSValidatieRegels.xml`, each generating its own `vX/doc/NLCSValidatieRegels.html`. The stylesheet, CSS and XSD in the root `doc/` are shared. |
| `sys_config.xml` | One full block per version (`<version id="v12.1">…</version>`) holding every value; no defaults/inheritance. |
| `localization/messages.xml` | Shared. Changed text for a rule = a new message id used by the overriding pattern; old ids remain for older versions. |
| `user_config.xml` | Shared. |
| Rule test data (`vX/test/rule_validation_data`) | Follows `main.sch`: a rule's fixtures are taken from the version folder its pattern is included from. A version folder only holds fixtures for rules it added or changed. Rules not in `main.sch` are not run. |
| Scope test data (`vX/test/scope_validation_data`) | One `scope_template.xml` per version, copied when the version is created. |
| XSD | Downloaded per version into `schemas/<NLCS++ version>/`. |
| Test-data SVGs (`assets`) | Per version: `vX/assets/`, generated by `generate_and_compare_svgs.sh`. |

## Version selection at validation time

* By default the version is **detected from the file**: the NLCS++ version
  in the `VersieNummer` attribute of the root `<NLCSnetbeheer>` (e.g.
  `VersieNummer="12.1"`) selects the version with that id (`v12.1`).
  `xsi:schemaLocation` is not used. (Revised 2026-10-29; detection used
  `xsi:schemaLocation` before.)
* An optional **`version` parameter** selects a version explicitly. It
  accepts only the folder name (`v12.1`).
* If `VersieNummer` is missing (it is optional in the XSD) or no version
  exists for it, validation **fails with an explicit error**
  ("unsupported NLCS version") rather than falling back.
* Every test XML declares `VersieNummer` equal to its folder's NLCS++
  version; `scripts/validate_test_data_xsd.sh` checks this per version.

## CI

CI runs **every version on every PR**, as a matrix with one job per
version, because a change to an older version's file and shared edits can
affect all versions that include it.

Because includes are written by hand, CI also checks every version's
`main.sch`:

* every include points to an existing file;
* every phase has its pattern include(s) and every pattern include has a
  phase;
* includes only point to the version itself or older versions;
* all pattern files of a rule come from one version, and a version with
  its own pattern for a rule also has that rule's test data;
* `active_version` equals the folder name (already checked by
  `scripts/check_active_version.sh`).

## Testing the model

`v12` (formerly the fictional `v9999.1.0`) adds one rule (`R.44`), removes
one rule (`R.13`) and edits one rule (`R.15`) compared to `v12.1`, to prove
isolation and inheritance end to end. Its rule changes are fictional.

# Release packaging

Decided 2026-11-04: **one zip** with every version; see
[build-and-release](../architecture/build-and-release).

The version registry format was settled as XML; see
[version-registry](../config/version-registry). The remaining
implementation steps are in [multiversion-plan](../architecture/multiversion-plan).
