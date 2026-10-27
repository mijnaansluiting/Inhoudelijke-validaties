# Configuration

Files that tune rule behavior without changing Schematron/XSLT code.

* [System configuration (sys_config.xml)](./sys-config) - Version-scoped thresholds, allowed-value lists, and exceptions consumed by several validation rules.
* [Version registry (versions.xml)](./version-registry) - The single list of rule-set versions, their target XSD, base and released flag; read by scripts, CI and XSL.
* [User configuration (user_config.xml)](./user-config) - The single language setting that selects which localized message text validation reports use.
* [Localization messages (messages.xml)](./localization-messages) - The nl/en message catalog that validation rules use to produce human-readable failure text.
