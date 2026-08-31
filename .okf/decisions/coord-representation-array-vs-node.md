---
type: Decision
title: Adopted array(xs:double) coordinate representation (~34% faster than Coord nodes)
description: Benchmark finding that representing parsed coordinates as Coord XML element nodes was measurably slower than a flat array(xs:double) representation, independent of the caching/connectivity-index wins; subsequently adopted.
tags: decision, performance, geometry
generated:
  by: human:sytse.walraven
  at: 2026-08-26T00:00:00Z
sources:
  - resource: "../../COORD_PARSING_BENCHMARK.md"
    title: "COORD_PARSING_BENCHMARK.md"
  - resource: "../../validation_schemas/xsl_functions/helper_functions.xsl"
    title: "helper_functions.xsl"
  - resource: "../../validation_schemas/xsl_functions/geometry_functions.xsl"
    title: "geometry_functions.xsl"
  - resource: "./geometry-parse-caching"
    title: "geometry-parse-caching"
  - resource: "./connectivity-index-and-geometry-caching"
    title: "connectivity-index-and-geometry-caching"
---

# Context

[geometry-parse-caching](./geometry-parse-caching) and
[connectivity-index-and-geometry-caching](./connectivity-index-and-geometry-caching)
both improved performance without questioning the coordinate
*representation* itself: parsed geometry had been a sequence of `Coord` XML
element nodes (`<Coord><X>.../X><Y>.../Y></Coord>`) ever since the shared
`ma:parse-point`/`ma:parse-line`/`ma:parse-area` abstraction in
[helper_functions.xsl](../architecture/xsl-function-libraries) was
introduced between release `v12.0.0` and `v12.1.0` — confirmed via
`git show v12.1.0:validation_schemas/xsl_functions/helper_functions.xsl`,
the `Coord`-node shape already existed at v12.1.0, only the memoization
wrapper came later. Before v12.0.0 there was no shared parse function at
all: every rule inlined `tokenize(normalize-space(...))` into a **flat
sequence of `xs:double`**, indexed positionally, with fully separate 2D/3D
function variants.

Question investigated: is constructing `Coord` element nodes (vs. plain
numeric values) itself a meaningful cost, separate from the caching/index
wins already measured?

# Method

A literal flat `xs:double*` sequence (the true v12.0.0 style) can't coexist
with the current unified 2D/3D `geometry_functions.xsl`, which relies
throughout on per-vertex sequence operations (`$line[1]`,
`subsequence($line, $i, 2)`, `min($line/X)`). Reproducing v12.0.0's
duplicated 2D/3D function set would be a much larger, unrelated rewrite.
Instead, a parsed point is now represented as
**`array(xs:double)`** (`array{x, y}` / `array{x, y, z}`) — a genuine list of
doubles with zero XML node-construction overhead, while
`array(xs:double)*` stayed a flat, indexable sequence so every existing
per-vertex operation (`$line[1]`, `subsequence`, `count`) kept working
unchanged. This isolated the one variable (element-node construction) while
holding the memoized-cache architecture, connectivity index, and full 41-rule
set constant. Changes were confined to `helper_functions.xsl`,
`geometry_functions.xsl`, and one type annotation in
`connectivity_functions.xsl` — no `.sch` abstract pattern needed to change,
since they only call the `ma:*` functions and index parsed lines
positionally, never dereferencing `/X` etc. directly.

Full methodology, substitution table, and raw data:
[COORD_PARSING_BENCHMARK.md](../../COORD_PARSING_BENCHMARK.md).

# Verification

- All 41 rules' `passing`/`failing` fixtures
  ([rule-test-fixtures](../testing/rule-test-fixtures)) produced
  byte-identical SVRL output between the current `Coord`-node code and the
  array-based variant (after excluding a leaked `xmlns:array` namespace
  declaration via `exclude-result-prefixes`).
- `benchmark.xml` compiled under both variants produced exactly the same
  7388 `svrl:failed-assert`/`svrl:successful-report` count.

# Finding

`benchmark.sh` against `benchmark.xml`, 10 runs per variant, controlled
comparison (same 41 rules, same memoized-cache + connectivity-index
architecture, only the representation differs):

| Variant | Coord representation | Mean | Stdev |
|---|---|---|---|
| pre-migration | `Coord` element nodes | 11.00s | 0.67 |
| adopted | `array(xs:double)` | 7.30s | 0.67 |

**11.00s → 7.30s: a 3.70s / 33.6% reduction.** `Coord`-element-node
construction and traversal (`generate-id()` cache keys, node copying when
`Coord` sequences are subsequenced/reversed/passed around, element
construction in `ma:coord`) is a real, measurable cost at `benchmark.xml`
scale — smaller than the prior caching/connectivity-index wins (132s → 27s →
10s) but not noise: roughly the same order of magnitude as the
memoized-parsing win alone (~2.7x) layered on top of an already
cached/indexed baseline (~1.5x further).

`dist_v12.0.0` (30 rules, no cache, no connectivity index, flat doubles) was
also benchmarked for historical context (5.10s mean) but is **not** a
controlled data point — it differs from current in four ways at once, not
just representation.

# Status

**Adopted (2026-07-27).** This started as an investigation — the experimental
`array(xs:double)` code was first reverted (`git checkout --`) after the
initial benchmark, weighing the ~34% win against touching every consumer in
`geometry_functions.xsl`/`helper_functions.xsl`/`connectivity_functions.xsl`.
It was subsequently re-applied to the same 3 files (byte-identical to the
investigation's already-verified code, copied from the `dist_old_parsing/`
snapshot) and re-verified before landing: fixture PASS/FAIL and the
`benchmark.xml` 7388-assert count both stayed identical, and a freshly rebuilt
`dist/` benchmarked at ~7.6s mean (5 runs), consistent with the original
`array(xs:double)` measurement. The committed codebase now uses
`array(xs:double)`, not `Coord` element nodes.
