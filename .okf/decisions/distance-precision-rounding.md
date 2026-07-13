---
type: Decision
title: Rounding geometric comparisons to millimeters
description: Why distance/touch checks round to a configured decimal precision instead of comparing raw floating-point doubles.
tags: decision, geometry
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Context

Several geometric checks — [R.3](/rules/R.3.md) (geometry within project
area), [R.4](/rules/R.4.md) (line segment length/angle), and
[R.36](/rules/R.36.md) (duct-to-content distance) — rely on
`geometry_functions.xsl` computing whether two coordinates are "the same
point," whether a point lies exactly on a segment, or whether a buffered line
touches an area. Comparing raw `xs:double` results of floating-point distance
math directly (`= 0`, `a + b = c`) is fragile: real-world surveyed
coordinates that are geometrically coincident can differ by a
floating-point epsilon, causing an intersection/touch check to spuriously
fail.

# Decision

Two related fixes, in order:

1. **`5a58dee` — "R.36: Fix line buffer calculation with sequential coords
   at same position" (#90)** (2026-05-01). `ma:buffer-line`'s
   left/right-bounds construction produced degenerate orthogonal segments
   when two sequential coordinates in a line were at the exact same
   position (segment length 0) — a legitimate scenario for surveyed/GML
   data with duplicate vertices. Fixed by skipping zero-length segments
   when building the buffer's bounding polygon (`ma:segment-length($segment)
   != 0` guard), verified with a new `complex.xml` fixture exercising
   exactly this shape (see [rule-test-fixtures](/testing/rule-test-fixtures.md)).

2. **`1e78ce1` — "Limit rounding to millimeters for final interaction
   checks" (#92)** (2026-05-07). Introduced `configuration/sys_config.xml`'s
   `DecimalPrecision` (`3`, i.e. millimeter precision at the project's
   coordinate units) and a new `ma:trim-decimals` helper
   (`round($number * 10^precision) div 10^precision`) in
   [config/sys-config.md](/config/sys-config.md)-backed
   `helper_functions.xsl`. `ma:point-equals-point` and
   `ma:point-touches-segment` now round both sides of their equality checks
   through `ma:trim-decimals` before comparing, instead of comparing raw
   doubles. `ma:line-touches-area` also gained an additional interaction
   check (`some $point in $area satisfies ma:point-touches-line($point,
   $line)`) to catch a line barely touching an area's boundary — verified
   with the new `line_barely_touching_area.xml` fixture under
   [R.3](/rules/R.3.md).

# Why this matters

Any new geometric check built on `point-equals-point`, `point-touches-segment`,
or `line-touches-area` inherits millimeter-level tolerance automatically —
don't reintroduce raw `=` comparisons on distance/coordinate doubles, and
don't change `DecimalPrecision` without checking which rules' pass/fail
fixtures assume 1mm tolerance (notably [R.36](/rules/R.36.md)'s `_offset`
and `exact_same_position` fixtures).

# Citations

[1] [5a58dee — R.36: Fix line buffer calculation with sequential coords at same position (#90)](https://github.com/mijnaansluiting/Inhoudelijke-validaties/commit/5a58dee5ae6f40613922d7ad15207575701a2d7a)
[2] [1e78ce1 — Limit rounding to millimeters for final interaction checks (#92)](https://github.com/mijnaansluiting/Inhoudelijke-validaties/commit/1e78ce1313103608cae025b24ac141a9d7403b31)
[3] [geometry_functions.xsl](../../validation_schemas/xsl_functions/geometry_functions.xsl)
[4] [helper_functions.xsl](../../validation_schemas/xsl_functions/helper_functions.xsl)
