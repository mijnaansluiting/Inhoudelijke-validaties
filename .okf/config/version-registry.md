---
type: Configuration
title: Version registry (versions.xml)
description: The single list of NLCS++ versions that have a rule folder; read by scripts, CI and the XSL version-selection functions.
resource: configuration/versions.xml
tags: configuration, versioning
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-10T00:00:00Z
sources:
  - resource: "../../configuration/versions.xml"
    title: "versions.xml"
  - resource: "../../scripts/versions.sh"
    title: "versions.sh"
  - resource: "../../v12.1/xsl_functions/version_functions.xsl"
    title: "version_functions.xsl"
---

# Overview

`configuration/versions.xml` lists the versions the repository holds rules
for. A version is an **NLCS++ version** (see
[multiversion-model](../decisions/multiversion-model)): its id is the NLCS++
version prefixed with `v` and equals its root folder name (e.g. `v12.1/`).
Scripts, CI and XSL read the list from here instead of hardcoding folder
names.

# Schema

One `<version/>` element per line (the bash helper parses lines, not XML).
There is no schema for the registry; `scripts/check_active_version.sh`
checks that every registered version has a `<version>/rules/main.sch`
declaring a matching `active_version`, a `sys_config` block and a catalog
`<version>/doc/NLCSValidatieRegels.xml`, and that every `v*/` root folder is
registered.

| Attribute | Required | Meaning |
|---|---|---|
| `id` | yes | Folder name: `v` + the NLCS++ (NLCS_Netbeheer XSD) version, e.g. `v12.1`. Unique. |

The XSD version is derived from the id (`v12.1` → `12.1`, so
`schemas/12.1/`), so there is no separate `nlcspp` attribute. There is no
`released` flag: every registered version is tested in CI, shipped and
selectable.

```xml
<version id="v12.1"/>
```

# Bash: scripts/versions.sh

| Command | Output |
|---|---|
| `list` | All ids, oldest first (`sort -V`, so `v12.10` comes after `v12.9`). |
| `latest` | Newest version. |
| `resolve <version>` | The id itself if it is registered; fails otherwise. Only the folder name is accepted (`v12.1`, not `12.1`). |
| `xsd <version>` | That version's XSD version: the id without the `v`. |
| `rules <version>` | One `R.x <version>` line per phase in `<version>/rules/main.sch`: the version folder the rule's pattern is included from, parsed from includes matching `(../../v*/rules/)?patterns/R.*` (a relative `patterns/R.x.sch` means the version itself). Scripts use it to find a rule's test data in `<that version>/test/rule_validation_data/`. |
| `xsds` | XSD versions of all versions. |
| `matrix` | JSON array of all ids, for a CI matrix. |

`VERSIONS_REGISTRY` overrides the file path (used for testing). Every
per-version script in `scripts/` **requires** a version argument; there is no
default. Without one, `versions.sh resolve` stops with "a version is
required". The workflows pass the version explicitly. Scripts that work on
all versions at once (`check_active_version.sh`, `install_dependencies.sh`,
`bundle.sh`) take no argument; `validate_test_data_xsd.sh` takes an optional
one and checks every version without it.

# XSL: version_functions.xsl

`ma:select-version($document, $requested)` returns the version to validate
with: `$requested` if it is a registered id, else `v` + the `VersieNummer`
attribute of the file's root element (`ma:file-xsd-version`) if that is
registered. Empty means unsupported, and the caller must report that as an
error. Helpers: `ma:resolve-version`, `ma:file-xsd-version`,
`ma:version-for-xsd`. Not yet included by any `main.sch`; wiring happens with
the per-version dispatch.
