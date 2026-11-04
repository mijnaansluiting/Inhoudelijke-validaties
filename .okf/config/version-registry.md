---
type: Configuration
title: Version registry (versions.xml)
description: The single list of rule-set versions, the XSD version each targets and whether it is released; read by scripts, CI and the XSL version-selection functions.
resource: configuration/versions.xml
tags: configuration, versioning
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-03T00:00:00Z
sources:
  - resource: "../../configuration/versions.xml"
    title: "versions.xml"
  - resource: "../../scripts/versions.sh"
    title: "versions.sh"
  - resource: "../../version_functions.xsl"
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
checks that every registered version has a `<version>/rules/main.sch`
declaring a matching `active_version`, a `sys_config` block and a catalog
`<version>/doc/NLCSValidatieRegels.xml`, and that every `v*/` root folder is
registered.

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
| `rules <version>` | One `R.x <version>` line per phase in `<version>/rules/main.sch`: the version folder the rule's pattern is included from, parsed from includes matching `(../../v*/rules/)?patterns/R.*` (a relative `patterns/R.x.sch` means the version itself). Scripts use it to find a rule's test data in `<that version>/test/rule_validation_data/`. |
| `base <version>` | The registry's `base` field for that version (empty when absent). |
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
`ma:resolve-version`, `ma:file-xsd-version`, `ma:version-for-xsd`. The file
lives at the repository root next to its only caller, the
[version-dispatcher](../architecture/version-dispatcher) `validate.xsl`; no
`main.sch` includes it.
