---
type: Decision
title: Multiversion model
description: What a rule-set version is, how versions share and override schemas, config, catalog and test data, and how a version is selected at validation time.
tags: decision, versioning, architecture
status: draft
generated:
  by: claude-opus-5-5
  at: 2026-10-27T00:00:00Z
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
  `v2026.1.1`). Because of that, nothing may hardcode another version's
  folder path. Base references and paths are resolved through the version
  registry, so a fix rename only touches the folder and its registry
  entry.
* Rule-set versions map **many-to-one** onto XSD versions: each rule-set
  version targets exactly one XSD version, several may share one
  (`v2026.1.0` → XSD `12.1`).
* **All released versions stay supported** — in the repo, in CI and
  selectable at validation time.

## Rule numbering

Rule numbers are never reused. An edited rule keeps its number; a removed
rule's number is retired; a new rule gets the next free number globally.

## Sharing and overriding

* The **first version (`v2026.1.0`) is the base**; there is no separate
  `shared/` directory. Later versions include files from the base and only
  hold what differs.
* The **unit of override is a concrete pattern file.** A version's
  `main.sch` lists, per rule, whether it includes the base's
  `patterns/R.x.sch` or its own. Editing a rule = copy its pattern file into
  the version and change it. Removing a rule = not including it (no phase,
  no pattern).
* **Base files never get behavior changes.** A behavior change always goes
  into the version folder as an override. Base files may receive fixes,
  and later versions that include a base file **inherit** those fixes. If a
  later version must not inherit a fix, it overrides the file first.
* **Abstract patterns are not overridden.** When a version needs different
  abstract-pattern behavior, a *new* abstract pattern (new id/file) is
  added and the version's overriding concrete pattern uses it; the old one
  stays untouched.
* **Shared XSL function libraries** (`validation_schemas/xsl_functions/`)
  stay a single shared copy and must remain backwards compatible: a change
  must not alter results of any supported version. New behavior means a
  new function, not a changed one.
* **Bugs found in a rule present in several versions** are handled case by
  case; the decision is recorded in the PR.

## Version-specific data

| Item | Model |
|---|---|
| Rule catalog (`NLCSValidatieRegels.xml`) | One full file per version: `doc/vX/NLCSValidatieRegels.xml`, each generating its own HTML. |
| `sys_config.xml` | One full block per version (`<version id="v2026.1.0">…</version>`) holding every value; no defaults/inheritance. |
| `localization/messages.xml` | Shared. Changed text for a rule = a new message id used by the overriding pattern; old ids remain for older versions. |
| `user_config.xml` | Shared. |
| Rule test data (`test/rule_validation_data`) | Base + overrides, same as patterns: a version inherits the base's fixtures and only holds fixtures for rules it added or changed. Removed rules' fixtures are not run. |
| Scope test data (`test/scope_validation_data`) | Base + overrides. |
| XSD | Downloaded per targeted XSD version. |

## Version selection at validation time

* By default the version is **detected from the file**: the XSD version in
  `xsi:schemaLocation` (e.g. `…/V12.1/…`) selects the **newest supported
  rule-set version targeting that XSD**.
* An optional **`version` parameter** selects any supported version
  explicitly; this is how older versions sharing an XSD stay reachable.
  It accepts both a full id (`v2026.1.0`) and a `vYEAR.RELEASE` alias
  (`v2026.1`) meaning the newest fix of that release. Callers that pin the
  alias keep working when a fix renames the folder; a pinned full id stops
  resolving once that fix is renamed away.
* If the XSD version is missing or not targeted by any supported version,
  validation **fails with an explicit error** ("unsupported NLCS version")
  rather than falling back.

## CI

CI runs **every supported version on every PR**, because base and shared
edits can affect all of them.

## Testing the model

A fictional `v2026.2.0` is created from `v2026.1.0` that adds one rule, removes
one rule and edits one rule, to prove isolation and inheritance end to end.
It is deleted once the infrastructure is proven and is never shipped.

# Open questions

* **Release packaging** — one zip with all versions, a zip per version, or
  both. To be decided later.

The version registry format was settled as XML; see
[version-registry](../config/version-registry).
