---
type: Architecture Component
title: Build and release
description: How the scope-checked schema, config, and docs are packaged into the versioned deliverable consumers actually use.
resource: scripts/bundle.sh
tags: [architecture, release]
timestamp: 2026-07-08T00:00:00Z
---

# Overview

The artifact netbeheerders/contractors actually consume isn't this source
repo directly — it's a packaged zip produced by `scripts/bundle.sh` and
published as a GitHub Release asset by the `Deliverables` workflow (see
[ci/workflows](/ci/workflows.md)) whenever a `v*` tag is pushed.

`bundle.sh` assembles a `dist/` directory containing:
- the **scope-checked** base schema, transpiled to XSLT
  (`validation_schemas/base_scope_checks/v12.xsl` — see
  [compilation-pipeline](/architecture/compilation-pipeline.md) for how the
  scope-checked variant is produced) under `dist/src/base/`
- the [xsl-function-libraries](/architecture/xsl-function-libraries.md) under
  `dist/src/xsl_functions/`
- `configuration/` (both `sys_config.xml` and `user_config.xml`) under
  `dist/configuration/`
- `doc/NLCSValidatieRegels.xml` (the rule catalog itself — needed at runtime
  by `rule_scope_functions.xsl`) under `dist/doc/`
- `localization/messages.xml` under `dist/localization/`

...then zips `dist/` as `nlcspp_inhoudelijke_validaties.zip`. This is the
"run the same validations on every device" deliverable the
[project's stated goal](/domain/nlcs-plus-plus.md) refers to: a
self-contained bundle a consumer can run against their own NLCS++ files with
just Saxon, no dependency on this build toolchain.

# Version scoping

Everything here is versioned under `v12` (matching the external
`NLCS_Netbeheer` XSD version, currently `12.1` per
`scripts/install_dependencies.sh`'s `NLCS_NETBEHEER_VERSION`). A future
schema version would add parallel `v13` directories rather than replacing
`v12` in place.

# Citations

[1] [bundle.sh](../../scripts/bundle.sh)
[2] [Deliverables.yml](../../.github/workflows/Deliverables.yml)
