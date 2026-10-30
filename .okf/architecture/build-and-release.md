---
type: Architecture Component
title: Build and release
description: How the scope-checked schema, config, and docs are packaged into the versioned deliverable consumers actually use.
resource: scripts/bundle.sh
tags: architecture, release
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
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

`bundle.sh` assembles a `dist/` directory containing:
- the **scope-checked** schema of the bundled version, transpiled to XSLT
  (`validation_schemas/<version>/transpiled_phases/main_scope_checks.xsl` —
  see [compilation-pipeline](./compilation-pipeline) for how the
  scope-checked variant is produced), as `dist/src/base/<version>/main.xsl`.
  It sits two folders below `dist/src/` because it includes
  `../../xsl_functions/`.
- the [xsl-function-libraries](./xsl-function-libraries) under
  `dist/src/xsl_functions/`
- `configuration/` (`sys_config.xml`, `user_config.xml`, `versions.xml`)
  under `dist/configuration/`
- the version's rule catalog (`doc/<version>/NLCSValidatieRegels.xml`,
  needed at runtime by `rule_scope_functions.xsl`) under
  `dist/doc/<version>/`
- `localization/messages.xml` under `dist/localization/`

...then zips `dist/` as `nlcspp_inhoudelijke_validaties.zip`. This is the
"run the same validations on every device" deliverable the
[project's stated goal](../domain/nlcs-plus-plus) refers to: a
self-contained bundle a consumer can run against their own NLCS++ files with
just Saxon, no dependency on this build toolchain.

# Version scoping

The bundle currently ships a single rule-set version (`v2026.1.0`, targeting
`NLCS_Netbeheer` XSD `12.1` per `scripts/install_dependencies.sh`'s
`NLCS_NETBEHEER_VERSION`). Rule-set versions are decoupled from XSD versions
and will be packaged side by side; see
[multiversion-model](../decisions/multiversion-model). How multiple versions
are packaged is still open.
