---
type: Configuration
title: System configuration (sys_config.xml)
description: Version-scoped thresholds, allowed-value lists, and exceptions consumed by several validation rules.
resource: configuration/sys_config.xml
tags: configuration
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../configuration/sys_config.xml"
    title: "sys_config.xml"
  - resource: "../../validation_schemas/xsl_functions/config_functions.xsl"
    title: "config_functions.xsl"
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
| `MofFuncties/Aftak` | `AFTAK SPLITSEND` | [R.26](../rules/R.26) — maps joint Functie values to the "Aftak" category. |
| `MofFuncties/Eind` | `EINDMOF`, `EINDDOP`, `LOODKOP`, `EIND GEAARD` | [R.26](../rules/R.26) — "Eind" category. |
| `MofFuncties/Verbinding` | `VERBINDING`, `ZEGELWIJZIGING`, `MANTELREPARATIE` | [R.26](../rules/R.26) — "Verbinding" category. |
| `MofFuncties/Faseovergang` | `3FASE 3x1FASE` | [R.26](../rules/R.26) — "Faseovergang" category. |
| `ToegestaandeInmeetwijzen/Inmeetwijze` | `GPS`, `Tachymeter` | [R.37](../rules/R.37) — allowed survey-method values. |
| `GisIdAssetsIdExceptions/NoGisIdRequired` | `AmantelbuisInhoud` | [R.5](../rules/R.5) — object types exempt from the GisId requirement. |
| `MantelbuisInhoudMaxAfstand` | `1` (meter) | [R.36](../rules/R.36) — max allowed distance between a protection pipe and its content. |

`GisIdAssetsIdExceptions` also has a commented-out `NoAssetIdRequired` slot,
reserved for future AssetId exceptions but currently unused.

# Related

[user-config.md](./user-config) holds the separate `Language`
setting consumed by [localization-messages](./localization-messages).
The `DecimalPrecision`/rounding behavior here is closely related to the
geometric precision issues discussed in
[distance-precision-rounding](../decisions/distance-precision-rounding).
