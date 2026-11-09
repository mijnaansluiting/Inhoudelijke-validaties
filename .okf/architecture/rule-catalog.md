---
type: Data Format
title: Rule catalog (NLCSValidatieRegels.xml)
description: The per-version rule catalog XML, its shared XSD, and the XSL that renders it to the HTML documentation.
resource: doc/NLCSValidatieRegels.xsd
tags: documentation, schema, rules
generated:
  by: claude-code/opus-5-5
  at: 2026-11-05T00:00:00Z
sources:
  - id: xsd
    resource: "../../doc/NLCSValidatieRegels.xsd"
    title: "NLCSValidatieRegels.xsd"
  - id: xsl
    resource: "../../doc/NLCSValidatieRegels.xsl"
    title: "NLCSValidatieRegels.xsl"
  - id: catalog-v12
    resource: "../../v12/doc/NLCSValidatieRegels.xml"
    title: "v12 rule catalog"
---

# Overview

Every NLCS++ version folder has its own rule catalog,
`<version>/doc/NLCSValidatieRegels.xml` (namespace
`NLCSValidatieRegelsNameSpace`). It is the source of truth for the rule
metadata described in [rules](../rules/index) and for the scopes in the
[scope × severity model](../domain/scope-severity-model). All versions share
one schema, `doc/NLCSValidatieRegels.xsd`, and one stylesheet,
`doc/NLCSValidatieRegels.xsl`, which renders the catalog to
`<version>/doc/NLCSValidatieRegels.html`.

# Schema

Root `NLCSValidatieregels` holds `validatieRegels` followed by `scopes`.

Each `validatieRegel` (`ValidatieRegelType`)[^xsd]:

| Item | Kind | Required | Content |
|---|---|---|---|
| `nummer` | attribute | yes | `xs:ID`, e.g. `R.1`; referenced from scopes via `xs:IDREF` |
| `naam` | attribute | yes | Rule name |
| `beschrijving` | element | yes | Short description |
| `soort` | element | yes | `SoortValidatieRegelType` (Bestand, Geometrie, Verplichte waarde, …) |
| `definitie` | element | yes | Definition the Schematron rule is implemented from |
| `toelichting` | element | no | Extra explanation |
| `validatieObjecten` | element | yes | List of `validatieObject/naam` (`NLCSObjectType`) |
| `laatstGewijzigd` | element | yes | `XsdVersieType`: the NLCS++ XSD version in which the rule was last changed |

`XsdVersieType` is an `xs:string` restricted to the pattern
`v[0-9]+(\.[0-9]+)*` (e.g. `v12`, `v12.1`), so a new NLCS++ version needs
no XSD change. As of 2026-11-05 every rule in both `v12/` and `v12.1/` has
`laatstGewijzigd` set to `v12`; it is a placeholder until the real per-rule
history is filled in.

Each `scope` has a `naam` attribute, a `tekeningSoort`, `statussen`,
`bedrijfsToestanden` and `scopeValidatieRegels` (pairs of `nummer` + `niveau`).

# HTML rendering

The XSL renders each rule as a table with one row per child element[^xsl].
Row labels are the element name with its first letter capitalised, except
`laatstGewijzigd`, which is shown as "Laatst gewijzigd". The HTML is
committed; CI regenerates it and fails if it differs. See
[ci/workflows](../ci/workflows) (`validate-docs` job).

# Consumers

* `v12/xsl_functions/rule_scope_functions.xsl` reads `soort` and the scopes at
  validation time ([xsl-function-libraries](./xsl-function-libraries)).
* `transformations/check_object_coverage.xsl`,
  `check_scope_coverage.xsl` and `generate_scoped_objects.xsl`
  ([coverage-checks](../testing/coverage-checks)).
* `scripts/check_rule_coverage.sh`, `check_active_version.sh` and
  `bundle.sh` ([build-and-release](./build-and-release)).

[^xsd]: `doc/NLCSValidatieRegels.xsd`, `ValidatieRegelType`.
[^xsl]: `doc/NLCSValidatieRegels.xsl`, templates `tablefy` and `human-string`.
