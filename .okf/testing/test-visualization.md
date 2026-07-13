---
type: Test Subsystem
title: Test data visualization
description: Auto-generated SVG renderings of every rule fixture's geometry, committed to assets/ for the wiki.
resource: transformations/visualize_test_data.xsl
tags: testing, documentation
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

`transformations/visualize_test_data.xsl` renders each
[rule test fixture](/testing/rule-test-fixtures.md)'s geometry (points,
lines, polygons — layered polygon→line→point→text, each object given a random
color) as an SVG. `scripts/generate_and_compare_svgs.sh` regenerates these
into `assets/R.<n>/<passing|failing>/*.svg`, removing files with no geometry
(empty `viewBox`) and empty directories.

These SVGs are **committed to the repo**, not build artifacts — they exist as
human-reviewable visual documentation of what each fixture geometrically
represents, intended for consumption on the project's external wiki. Because
they're checked in, `generate_and_compare_svgs.sh` fails CI
(`git diff --quiet assets/`) if regenerating them produces a diff, forcing
contributors to regenerate and commit SVGs whenever fixture geometry changes.
This runs as part of the `DocValidation` workflow — see
[ci/workflows](/ci/workflows.md) — since it's triggered by `doc/**` changes
alongside the HTML doc regeneration.

The equivalent script for the rendered rule-catalog HTML
(`doc/NLCSValidatieRegels.html`, generated from `doc/NLCSValidatieRegels.xml`
via `doc/NLCSValidatieRegels.xsl`) is `scripts/generate_and_compare_htmls.sh`,
which follows the same "regenerate and diff, fail if stale" pattern.

# Citations

[1] [generate_and_compare_svgs.sh](../../scripts/generate_and_compare_svgs.sh)
[2] [visualize_test_data.xsl](../../transformations/visualize_test_data.xsl)
