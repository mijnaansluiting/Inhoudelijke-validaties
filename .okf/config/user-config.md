---
type: Configuration
title: User configuration (user_config.xml)
description: The single language setting that selects which localized message text validation reports use.
resource: configuration/user_config.xml
tags: configuration, localization
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../configuration/user_config.xml"
    title: "user_config.xml"
  - resource: "../../validation_schemas/xsl_functions/localization_functions.xsl"
    title: "localization_functions.xsl"
---

# Overview

`configuration/user_config.xml` is a minimal, per-run config file with a
single field:

```xml
<config>
    <Language>nl</Language>
</config>
```

`Language` (`nl` or `en`) selects which `xml:lang` variant
`validation_schemas/xsl_functions/localization_functions.xsl` picks when
resolving a message id from
[localization-messages](./localization-messages) for an SVRL assert
report.
