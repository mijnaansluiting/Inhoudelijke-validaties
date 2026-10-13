# Update Log

## 2026-08-26
* **Update**: Removed the non-OKF `published`, `editor`, `date`, and
  `dateCreated` frontmatter fields (added in a prior commit for Wiki.js
  compatibility) from all 56 concept files, so frontmatter is strictly
  OKF v0.2 fields. Wiki.js can no longer consume these files directly as
  page frontmatter — that compatibility was intentionally dropped.
  `generated.by`/`generated.at` updated to reflect this edit.

## 2026-07-27
* **Update**: Adopted the `array(xs:double)` coordinate representation
  investigated earlier the same day — see
  [coord-representation-array-vs-node](./decisions/coord-representation-array-vs-node)
  (now updated with an adoption record) and
  [COORD_PARSING_BENCHMARK.md](../COORD_PARSING_BENCHMARK.md). Re-applied the
  same already-verified 3-file change (`helper_functions.xsl`,
  `geometry_functions.xsl`, `connectivity_functions.xsl`) to the committed
  source, re-confirmed identical fixture PASS/FAIL and the identical
  7388-assert `benchmark.xml` SVRL count, then rebuilt the real `dist/` and
  reconfirmed the ~7.3s figure (5 runs, ~7.6s mean) on the actual shipped
  artifact rather than just the investigation's snapshot copy. Cross-linked
  from [xsl-function-libraries](./architecture/xsl-function-libraries).

## 2026-07-27
* **Update**: Investigated whether `Coord`-element-node coordinate parsing
  costs performance vs. a flat `array(xs:double)` representation, independent
  of the memoized-cache/connectivity-index architecture — see
  [coord-representation-array-vs-node](./decisions/coord-representation-array-vs-node)
  and [COORD_PARSING_BENCHMARK.md](../COORD_PARSING_BENCHMARK.md) at the repo
  root. Controlled `benchmark.xml` comparison (same 41 rules, same caching,
  only representation differs): 11.00s → 7.30s, a 33.6% reduction — a real,
  not-yet-acted-on cost. The experimental array-based code was reverted after
  benchmarking; `dist_current`/`dist_old_parsing` snapshots kept on disk
  alongside `dist_v12.0.0` for reference. Cross-linked from
  [xsl-function-libraries](./architecture/xsl-function-libraries) and
  [decisions/index](./decisions/index).

## 2026-07-10
* **Update**: Memoized `ma:parse-point`/`ma:parse-line`/`ma:parse-area` in
  `helper_functions.xsl` via lazily-built per-node caches — see
  [geometry-parse-caching](./decisions/geometry-parse-caching). Found while
  investigating a proposed quad tree for the remaining connectivity-index
  cost: [R.21](./rules/R.21)'s uncached endpoint scan was actually the
  dominant remaining cost, not the points×lines comparison the quad tree
  would have targeted. `benchmark.sh` against `benchmark.xml`: 27s → 10s,
  identical SVRL output (7389 asserts) and identical fixture PASS/FAIL
  across all 41 rules. Cross-linked from
  [connectivity-index-and-geometry-caching](./decisions/connectivity-index-and-geometry-caching),
  [R.21](./rules/R.21), and [xsl-function-libraries](./architecture/xsl-function-libraries).

## 2026-07-08
* **Creation**: Established the OKF bundle documenting the NLCS++ content-validation rule set — [domain](./domain/index) concepts, all 37 [rules](./rules/index), the [architecture](./architecture/index) of the Schematron/XSLT pipeline, [configuration](./config/index), [testing](./testing/index), [CI/CD](./ci/index), and two [decisions](./decisions/index) recovered from git history.
* **Update**: Added the [connectivity_functions.xsl](./architecture/xsl-function-libraries) shared touch index and the [connectivity-index-and-geometry-caching](./decisions/connectivity-index-and-geometry-caching) decision documenting the ~5x validation speedup for [R.20](./rules/R.20), [R.22](./rules/R.22), [R.23](./rules/R.23), [R.25](./rules/R.25), [R.26](./rules/R.26), and [R.39](./rules/R.39); cross-linked from those rule concepts.
