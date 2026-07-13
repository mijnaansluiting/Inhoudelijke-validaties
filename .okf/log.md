# Update Log

## 2026-07-10
* **Update**: Memoized `ma:parse-point`/`ma:parse-line`/`ma:parse-area` in
  `helper_functions.xsl` via lazily-built per-node caches — see
  [geometry-parse-caching](/decisions/geometry-parse-caching.md). Found while
  investigating a proposed quad tree for the remaining connectivity-index
  cost: [R.21](/rules/R.21.md)'s uncached endpoint scan was actually the
  dominant remaining cost, not the points×lines comparison the quad tree
  would have targeted. `benchmark.sh` against `benchmark.xml`: 27s → 10s,
  identical SVRL output (7389 asserts) and identical fixture PASS/FAIL
  across all 41 rules. Cross-linked from
  [connectivity-index-and-geometry-caching](/decisions/connectivity-index-and-geometry-caching.md),
  [R.21](/rules/R.21.md), and [xsl-function-libraries](/architecture/xsl-function-libraries.md).

## 2026-07-08
* **Creation**: Established the OKF bundle documenting the NLCS++ content-validation rule set — [domain](/domain/index.md) concepts, all 37 [rules](/rules/index.md), the [architecture](/architecture/index.md) of the Schematron/XSLT pipeline, [configuration](/config/index.md), [testing](/testing/index.md), [CI/CD](/ci/index.md), and two [decisions](/decisions/index.md) recovered from git history.
* **Update**: Added the [connectivity_functions.xsl](/architecture/xsl-function-libraries.md) shared touch index and the [connectivity-index-and-geometry-caching](/decisions/connectivity-index-and-geometry-caching.md) decision documenting the ~5x validation speedup for [R.20](/rules/R.20.md), [R.22](/rules/R.22.md), [R.23](/rules/R.23.md), [R.25](/rules/R.25.md), [R.26](/rules/R.26.md), and [R.39](/rules/R.39.md); cross-linked from those rule concepts.
