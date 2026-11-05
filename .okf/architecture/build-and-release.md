---
type: Architecture Component
title: Build and release
description: How the scope-checked schema, config, and docs are packaged into the versioned deliverable consumers actually use.
resource: scripts/bundle.sh
tags: architecture, release
generated:
  by: claude-code/opus-5-5
  at: 2026-11-05T00:00:00Z
sources:
  - resource: "../../scripts/bundle.sh"
    title: "bundle.sh"
  - resource: "../../.github/workflows/Deliverables.yml"
    title: "Deliverables.yml"
---

# Overview

The artifact netbeheerders/contractors actually consume isn't this source
repo directly — it's a packaged zip produced by `scripts/bundle.sh` and
published as a GitHub Release asset by the `Deliverables` workflow (see
[ci/workflows](../ci/workflows)) whenever a `v*` tag is pushed.

`bundle.sh` assembles a `dist/` directory that **mirrors the repository
layout**, so every relative path in the compiled schema
(`../../xsl_functions/`, `../../../<older version>/xsl_functions/`) and in
the function libraries (`../../configuration/`, `../../localization/`,
`../../<version>/doc/`) resolves the
same way in `dist/` as in the repository:
- the **scope-checked** schema of the bundled version, transpiled to XSLT
  (`<version>/rules/transpiled_phases/main_scope_checks.xsl` — see
  [compilation-pipeline](./compilation-pipeline) for how the scope-checked
  variant is produced), at the same path
  `dist/<version>/rules/transpiled_phases/main_scope_checks.xsl`
- the [xsl-function-libraries](./xsl-function-libraries) of every version
  the bundled `main.sch` includes them from (its own and/or inherited ones,
  read from its `xsl:include` lines) under `dist/<that version>/xsl_functions/`
- `configuration/` (`sys_config.xml`, `user_config.xml`, `versions.xml`)
  under `dist/configuration/`
- the version's rule catalog (`<version>/doc/NLCSValidatieRegels.xml`,
  needed at runtime by `rule_scope_functions.xsl`) under
  `dist/<version>/doc/`
- `localization/messages.xml` under `dist/localization/`

...then zips `dist/` as `nlcspp_inhoudelijke_validaties.zip`. This is the
"run the same validations on every device" deliverable the
[project's stated goal](../domain/nlcs-plus-plus) refers to: a
self-contained bundle a consumer can run against their own NLCS++ files with
just Saxon, no dependency on this build toolchain.

# Version scoping

Decided 2026-11-04: **one zip with every version**; revised 2026-11-05, when
the `released` flag was dropped, so every registered NLCS++ version is shipped.
`bundle.sh` takes no argument; it loops over `versions.sh list` and copies the
files above for each. Consumers run the compiled schema of the NLCS++ version
they need, `dist/<version>/rules/transpiled_phases/main_scope_checks.xsl`
(e.g. `dist/v12.1/…`). `configuration/versions.xml` is bundled unchanged.
`bundle.sh` starts from an empty `dist/` and fails if a version's
`main_scope_checks.xsl` hasn't been compiled. The `Deliverables` workflow adds
scope checks to every version (a version's scope-checked schema includes the
scope-checked abstract patterns of the versions it inherits from) and compiles
every version before bundling. The software release number only exists as
the `v*` git tag that triggers the workflow and names the GitHub Release; the
zip is always `nlcspp_inhoudelijke_validaties.zip`.
