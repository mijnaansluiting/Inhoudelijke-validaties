---
type: Configuration
title: System configuration (sys_config.xml)
description: Version-scoped thresholds, allowed-value lists, and exceptions consumed by several validation rules.
resource: configuration/sys_config.xml
tags: configuration
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

`configuration/sys_config.xml` holds tunable values for rule logic, scoped
under a `<v12>` element matching the current NLCS++ version. Values are read
at validation time by functions in
`validation_schemas/xsl_functions/config_functions.xsl`, so a rule's actual
behavior can be adjusted without touching Schematron pattern code.

# Schema

| Field | Value (v12) | Used by |
|---|---|---|
| `DecimalPrecision` | `3` | Numeric rounding precision used across geometric/numeric comparisons. |
| `MofFuncties/Aftak` | `AFTAK SPLITSEND` | [R.26](/rules/R.26.md) — maps joint Functie values to the "Aftak" category. |
| `MofFuncties/Eind` | `EINDMOF`, `EINDDOP`, `LOODKOP`, `EIND GEAARD` | [R.26](/rules/R.26.md) — "Eind" category. |
| `MofFuncties/Verbinding` | `VERBINDING`, `ZEGELWIJZIGING`, `MANTELREPARATIE` | [R.26](/rules/R.26.md) — "Verbinding" category. |
| `MofFuncties/Faseovergang` | `3FASE 3x1FASE` | [R.26](/rules/R.26.md) — "Faseovergang" category. |
| `ToegestaandeInmeetwijzen/Inmeetwijze` | `GPS`, `Tachymeter` | [R.37](/rules/R.37.md) — allowed survey-method values. |
| `GisIdAssetsIdExceptions/NoGisIdRequired` | `AmantelbuisInhoud` | [R.5](/rules/R.5.md) — object types exempt from the GisId requirement. |
| `MantelbuisInhoudMaxAfstand` | `1` (meter) | [R.36](/rules/R.36.md) — max allowed distance between a protection pipe and its content. |

`GisIdAssetsIdExceptions` also has a commented-out `NoAssetIdRequired` slot,
reserved for future AssetId exceptions but currently unused.

# Related

[user-config.md](/config/user-config.md) holds the separate `Language`
setting consumed by [localization-messages](/config/localization-messages.md).
The `DecimalPrecision`/rounding behavior here is closely related to the
geometric precision issues discussed in
[distance-precision-rounding](/decisions/distance-precision-rounding.md).

# Citations

[1] [sys_config.xml](../../configuration/sys_config.xml)
[2] [config_functions.xsl](../../validation_schemas/xsl_functions/config_functions.xsl)
