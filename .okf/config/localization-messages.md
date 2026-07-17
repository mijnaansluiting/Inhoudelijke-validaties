---
type: Configuration
title: Localization messages (messages.xml)
description: The nl/en message catalog that validation rules use to produce human-readable failure text.
resource: localization/messages.xml
tags: configuration, localization
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

`localization/messages.xml` is a flat catalog of `<message id="...">` entries,
each with an `nl` and `en` `<message-text>` variant. Message text may contain
`{1}`, `{2}`, ... placeholders that
`validation_schemas/xsl_functions/localization_functions.xsl` substitutes with
rule-specific values (attribute names, expected/found values, thresholds)
before the text is attached to a Schematron `assert`. Which language variant
is picked is controlled by [user-config](./user-config)'s `Language`
setting.

Abstract pattern implementations call into this catalog by message id — each
[rule concept](../rules/index) that emits a specific message links back here.
Several ids are generic and reused across many "verplichte kenmerken" style
rules (e.g. `attribute-not-present`, `property-required-for-statuses`), while
others are specific to a single rule (e.g.
`inhoud-assets-not-in-range-of-mantelbuis` for
[R.36](../rules/R.36)).

# Schema

| Message id | Used for |
|---|---|
| `no-nlcs-objects-present` | [R.1](../rules/R.1) — file has no NLCS objects. |
| `invalid-status-for-tekening-type` | [R.2](../rules/R.2) — Status not allowed for the Tekeningsoort. |
| `object-outside-project-area` | [R.3](../rules/R.3) — geometry outside the project area. |
| `line-segment-measurement-incorrect` | [R.4](../rules/R.4) (R.4-A) — segment shorter than 10cm or longer than 50m. |
| `line-angle-larger-than-45` | [R.4](../rules/R.4) (R.4-B) — angle between segments exceeds 45°. |
| `attribute-not-present` / `attribute-present` | Generic mandatory-attribute presence/absence checks (R.9–R.15, R.40, R.41, etc). |
| `property-required-for-statuses` / `property-not-allowed-for-statuses` | Generic status-conditional attribute checks (e.g. R.5). |
| `object-not-present` | Generic required-related-object checks (R.31–R.33). |
| `date-in-the-future` | [R.9](../rules/R.9), [R.41](../rules/R.41) — a date attribute is in the future. |
| `point-not-connected-to-any-line` | [R.20](../rules/R.20) — point object not connected to a cable. |
| `cable-not-connected-to-valid-object` | [R.21](../rules/R.21) — invalid cable endpoint. |
| `connected-cable-does-not-match-netvlak` | [R.22](../rules/R.22) — joined cables differ in netvlak. |
| `connected-cable-does-not-match-property` | [R.23](../rules/R.23) — joined cables differ in a shared attribute. |
| `fase-not-the-same-as-uitvoering` | [R.24](../rules/R.24) — Fase/Uitvoering mismatch. |
| `connected-fases-not-allowed` / `connected-fases-do-not-match` / `connected-fases-do-not-split` | [R.25](../rules/R.25) — phase-combination checks at a joint. |
| `cable-amount-incorrect` / `cable-amount-unknown` / `existing-cable-not-connected-to-new-cable` | [R.26](../rules/R.26) — cable-count-vs-Functie checks. |
| `mantelbuis-inhoud-diameter-larger-than-own` | [R.27](../rules/R.27) — nested duct diameter too large. |
| `inhoud-found` / `inhoud-not-found` | [R.28](../rules/R.28) — duct-content presence/absence vs Bedrijfstoestand. |
| `verplaatsing-incorrectly-applied` | [R.29](../rules/R.29) — relocation not recorded with a matching pair. |
| `mantelbuis-inhoud-is-self` / `mantelbuis-id-does-not-refer-to-mantelbuis` / `object-type-inhoud-does-not-match-inhoud` | [R.30](../rules/R.30) — duct-content reference checks. |
| `soort-bestand-not-correct` | [R.31](../rules/R.31)–[R.33](../rules/R.33) — attached-document SoortBestand mismatch. |
| `revisie-no-maaiveldhoogte-present` | [R.35](../rules/R.35) — missing ground-level object in a revision. |
| `inmeetwijze-not-allowed` | [R.37](../rules/R.37), [R.38](../rules/R.38) — disallowed survey method. |
| `inhoud-assets-not-in-range-of-mantelbuis` | [R.36](../rules/R.36) — duct content farther than the configured max distance. |
| `connected-cables-have-different-verbindingnummer` | [R.39](../rules/R.39) — cable/joint Verbindingnummer mismatch. |

This table lists the ids confirmed while authoring the rule concepts; it is
not necessarily exhaustive of every id in the file.

# Citations

[1] [messages.xml](../../localization/messages.xml)
[2] [localization_functions.xsl](../../validation_schemas/xsl_functions/localization_functions.xsl)
