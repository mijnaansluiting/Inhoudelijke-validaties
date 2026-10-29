---
type: Configuration
title: Version registry (versions.xml)
description: The single list of rule-set versions, the XSD version each targets and whether it is released; read by scripts, CI and the XSL version-selection functions.
resource: configuration/versions.xml
tags: configuration, versioning
status: draft
generated:
  by: claude-opus-5-5
  at: 2026-10-27T00:00:00Z
sources:
  - resource: "../../configuration/versions.xml"
    title: "versions.xml"
  - resource: "../../scripts/versions.sh"
    title: "versions.sh"
  - resource: "../../validation_schemas/xsl_functions/version_functions.xsl"
    title: "version_functions.xsl"
---

# Overview

`configuration/versions.xml` is the only place that names rule-set
versions. Scripts, CI and XSL look versions up here instead of hardcoding
folder names, so a fix rename (`v2026.1.0` → `v2026.1.1`, see
[multiversion-model](../decisions/multiversion-model)) only touches the
version folders and this file.

# Schema

One `<version/>` element per line (the bash helper parses lines, not XML).
There is no schema for the registry; `scripts/check_active_version.sh`
checks that every registered version has a schema folder, `sys_config`
block and catalog, and that every version folder is registered.

| Attribute | Required | Meaning |
|---|---|---|
| `id` | yes | Folder name, `vYEAR.RELEASE.FIX`. Unique. |
| `nlcspp` | yes | NLCS++ (NLCS_Netbeheer XSD) version targeted, e.g. `12.1`. |
| `released` | yes | `false` = tested in CI, but never shipped and never auto-selected. |

```xml
<version id="v2026.1.0" nlcspp="12.1" released="true"/>
```

# Bash: scripts/versions.sh

| Command | Output |
|---|---|
| `list [--released]` | All ids, oldest first (numeric sort, so `v2026.10.0` comes after `v2026.9.0`). |
| `latest [xsd]` | Newest released version, optionally for one XSD version. |
| `resolve <version>` | Full id for a full id or a `vYEAR.RELEASE` alias (newest fix); fails if unknown. |
| `xsd <version>` | That version's XSD version. |
| `sources <version>` | The version itself, then older released versions, newest first: the versions its `main.sch` may include from. |
| `xsds` | Distinct XSD versions. |
| `matrix` | JSON array of all ids, for a CI matrix. |

`VERSIONS_REGISTRY` overrides the file path (used for testing). Every
per-version script in `scripts/` **requires** a version argument (full id
or alias); there is no default. Without one, `versions.sh resolve` stops
with "a version is required". The workflows pass the version explicitly.
Scripts that work on all versions at once (`check_active_version.sh`,
`validate_test_data_xsd.sh`, `install_dependencies.sh`) take no argument.

# XSL: version_functions.xsl

`ma:select-version($document, $requested)` returns the version to validate
with: the resolved `$requested` if non-empty, else the newest released
version whose `nlcspp` equals the `VersieNummer` attribute of the file's
root element (`ma:file-xsd-version`). Empty means
unsupported, and the caller must report that as an error. Helpers:
`ma:resolve-version`, `ma:file-xsd-version`, `ma:version-for-xsd`. Not yet
included by any `main.sch`; wiring happens with the per-version
dispatch.
