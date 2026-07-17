---
type: Configuration
title: User configuration (user_config.xml)
description: The single language setting that selects which localized message text validation reports use.
resource: configuration/user_config.xml
tags: configuration, localization
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
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

# Citations

[1] [user_config.xml](../../configuration/user_config.xml)
[2] [localization_functions.xsl](../../validation_schemas/xsl_functions/localization_functions.xsl)
