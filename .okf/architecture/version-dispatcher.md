---
type: Architecture Component
title: Version dispatcher (validate.xsl)
description: The single entry point that selects a rule-set version for an NLCS++ file and runs that version's compiled schema with fn:transform().
resource: validate.xsl
tags: architecture, versioning
status: draft
generated:
  by: claude-code/opus-5-5
  at: 2026-11-03T00:00:00Z
sources:
  - resource: "../../validate.xsl"
    title: "validate.xsl"
  - resource: "../../version_functions.xsl"
    title: "version_functions.xsl"
---

# Overview

`validate.xsl` (repository root) is how a consumer validates a file without knowing which rule-set version applies:

```
java -jar saxon-he.jar -xsl:validate.xsl -s:file.xml [version=v2026.1.0 | version=v2026.1]
```

It implements the selection rules of
[multiversion-model](../decisions/multiversion-model):

1. With the optional **`version`** parameter: that version, as a full id
   (`v2026.1.0`) or a `vYEAR.RELEASE` alias (`v2026.1`, newest fix).
2. Otherwise: the newest **released** version whose `nlcspp` equals the
   `VersieNummer` attribute of the file's root element.

It then runs `<version>/rules/transpiled_phases/main_scope_checks.xsl` on the
file with `fn:transform()` and returns that schema's SVRL report unchanged.
The stylesheet path resolves relative to `validate.xsl`, so it works from any
working directory. The compiled schema keeps its own `active_version`; the
dispatcher passes no parameters to it.

# Errors

When no version can be selected, the dispatcher stops with
`xsl:message terminate="yes"` and error code `ma:unsupported-version`; Saxon
exits non-zero and writes no report. The message names the cause:

| Cause | Message |
|---|---|
| `version` parameter not in the registry | `Unknown rule-set version: <version>` |
| No `VersieNummer` on the root element | `Unsupported NLCS version: the root element declares no VersieNummer` |
| No released version targets the `VersieNummer` | `Unsupported NLCS version: no released rule-set version targets VersieNummer <n>` |

# Why fn:transform()

The compiled schema and function libraries already require XSLT 3.0
(`queryBinding="xslt3"`, maps, `||`), so `fn:transform()` adds no processor
requirement; Saxon-HE supports it. A static XSLT 2.0 dispatcher that imports
every version's compiled schema doesn't work: each version defines the same
modes, global parameters (`active_version`) and `ma:*` functions, and only one
definition of each can be active in a single stylesheet.

# Version functions

`version_functions.xsl` sits next to `validate.xsl` (not in a versioned
`xsl_functions/` folder, since selection must work for every version) and
reads `configuration/versions.xml`; see
[version-registry](../config/version-registry) for its functions.

# Output

The report is identical to running the version's compiled schema directly,
except that the `documents` attribute of `svrl:active-pattern` holds the
file's URI instead of being empty.
