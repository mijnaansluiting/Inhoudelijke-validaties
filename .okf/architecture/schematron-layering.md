---
type: Architecture Component
title: Schematron rule layering
description: The three-layer design that separates rule metadata from rule logic — base schema, concrete pattern, abstract pattern.
resource: validation_schemas/base/v12.sch
tags: architecture, schematron
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

The validation logic is a **Schematron** schema (`queryBinding="xslt3"`) split
across three layers so that rule metadata (id, scope, severity) stays separate
from the actual check logic, and so a single implementation can be reused by
sub-checks that only differ in parameters:

1. **`validation_schemas/base/v12.sch`** — the root schema. Declares
   namespaces (`ma`, `gml`, `xs`, `nlcs`, `nvr`, `math`), a global
   `<properties>` block (`scope`, `rule-number`, `severity`, `object-type`,
   `object-id`, `geometries` — attached to every assert for downstream
   reporting), one Schematron `<phase>` per rule id (`R.1` … `R.41`, with
   `R.4` and `R.8` each activating two patterns), the 5
   [xsl-function-libraries](/architecture/xsl-function-libraries.md) via
   `xsl:include`, then `include`s of every concrete pattern and every
   abstract pattern file.

2. **`validation_schemas/patterns/v12/R.<n>.sch`** (concrete patterns) — one
   per rule id (`R.4_A.sch`/`R.4_B.sch` and `R.8_A.sch`/`R.8_B.sch` for the
   two split rules). Each is a thin, non-abstract pattern that only sets
   `<param>`s — `rule_number`, `scope` (via `ma:scope-name(.)`), `severity`
   (via `ma:rule-severity-within-scope(<n>, .)`, see
   [scope-severity-model](/domain/scope-severity-model.md)), `object_type`,
   `object_id` — and declares `is-a="<abstract-pattern-id>"` to inherit the
   actual rule body. Example (`R.36.sch`):

   ```xml
   <pattern id="R.36" is-a="afstand-mantelbuis-tot-inhoud">
       <param name="rule_number" value="36"/>
       <param name="scope" value="ma:scope-name(.)"/>
       <param name="severity" value="ma:rule-severity-within-scope(36, .)"/>
       <param name="object_type" value="name(.)"/>
       <param name="object_id" value="nlcs:ID"/>
   </pattern>
   ```

3. **`validation_schemas/abstract_patterns/v12/<category>/<name>.sch`**
   (abstract patterns) — `abstract="true"` patterns containing the real
   `<rule context="...">`/`<assert>` XPath 3.0 logic. Grouped into 8 category
   directories that mirror each rule's `soort`: `bestand`, `consistentie`,
   `document`, `geometrie`, `inhoud_waarde`, `netlogica`, `topologie`,
   `verplichte_waarde`. Every [rule concept](/rules/index.md) links to its
   specific abstract pattern file.

This indirection means the concrete/abstract split can host multiple
concrete patterns pointing at one abstract implementation (parameterized
reuse), and keeps a rule's identity/metadata (id, scope wiring) decoupled
from what it actually checks.

# Turning this into something runnable

The `.sch` files above are Schematron source, not directly executable.
[compilation-pipeline](/architecture/compilation-pipeline.md) describes how
SchXSLT2 transpiles a chosen phase (rule) of this schema into standalone
XSLT that Saxon can run against an NLCS++ instance document.

# Citations

[1] [base/v12.sch](../../validation_schemas/base/v12.sch)
[2] [patterns/v12/R.36.sch](../../validation_schemas/patterns/v12/R.36.sch)
[3] [abstract_patterns/v12/geometrie/afstand_mantelbuis_tot_inhoud.sch](../../validation_schemas/abstract_patterns/v12/geometrie/afstand_mantelbuis_tot_inhoud.sch)
