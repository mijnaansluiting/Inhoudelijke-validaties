---
type: Architecture Component
title: Schematron rule layering
description: The three-layer design that separates rule metadata from rule logic — base schema, concrete pattern, abstract pattern.
resource: v2026.1.0/rules/main.sch
tags: architecture, schematron
generated:
  by: claude-code/opus-5-5
  at: 2026-11-02T00:00:00Z
sources:
  - resource: "../../v2026.1.0/rules/main.sch"
    title: "v2026.1.0/rules/main.sch"
  - resource: "../../v2026.1.0/rules/patterns/R.36.sch"
    title: "v2026.1.0/rules/patterns/R.36.sch"
  - resource: "../../v2026.1.0/rules/abstract_patterns/geometrie/afstand_mantelbuis_tot_inhoud.sch"
    title: "v2026.1.0/rules/abstract_patterns/geometrie/afstand_mantelbuis_tot_inhoud.sch"
---

# Overview

The validation logic is a **Schematron** schema (`queryBinding="xslt3"`) split
across three layers so that rule metadata (id, scope, severity) stays separate
from the actual check logic, and so a single implementation can be reused by
sub-checks that only differ in parameters:

1. **`<version>/rules/main.sch`** (e.g. `v2026.1.0/rules/main.sch`) — the
   root schema of a rule-set version. Declares
   namespaces (`ma`, `gml`, `xs`, `nlcs`, `nvr`, `math`), a global
   `<properties>` block (`scope`, `rule-number`, `severity`, `object-type`,
   `object-id`, `geometries`, `missing-attributes` — attached to asserts for
   downstream reporting), one Schematron `<phase>` per rule id (`R.1` … `R.41`, with
   `R.4` and `R.8` each activating two patterns), the 6
   [xsl-function-libraries](./xsl-function-libraries) via
   `xsl:include href="../../../xsl_functions/…"`, then `include`s of every
   concrete pattern and every abstract pattern file — the version's own
   (`patterns/R.<n>.sch`) or inherited from an older version folder
   (`../../v2026.1.0/rules/patterns/…`, `../../<version>/rules/abstract_patterns/…`;
   see [multiversion-model](../decisions/multiversion-model)).

2. **`<version>/rules/patterns/R.<n>.sch`** (concrete patterns) — one
   per rule id (`R.4_A.sch`/`R.4_B.sch` and `R.8_A.sch`/`R.8_B.sch` for the
   two split rules). Each is a thin, non-abstract pattern that only sets
   `<param>`s — `rule_number`, `scope` (via `ma:scope-name(.)`), `severity`
   (via `ma:rule-severity-within-scope(<n>, .)`, see
   [scope-severity-model](../domain/scope-severity-model)), `object_type`,
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

3. **`<version>/rules/abstract_patterns/<category>/<name>.sch`**
   (abstract patterns) — `abstract="true"` patterns containing the real
   `<rule context="...">`/`<assert>` XPath 3.0 logic. Grouped into 8 category
   directories that mirror each rule's `soort`: `bestand`, `consistentie`,
   `document`, `geometrie`, `inhoud_waarde`, `netlogica`, `topologie`,
   `verplichte_waarde`. Every [rule concept](../rules/index) links to its
   specific abstract pattern file.

This indirection means the concrete/abstract split can host multiple
concrete patterns pointing at one abstract implementation (parameterized
reuse), and keeps a rule's identity/metadata (id, scope wiring) decoupled
from what it actually checks.

# Turning this into something runnable

The `.sch` files above are Schematron source, not directly executable.
[compilation-pipeline](./compilation-pipeline) describes how
SchXSLT2 transpiles a chosen phase (rule) of this schema into standalone
XSLT that Saxon can run against an NLCS++ instance document.
