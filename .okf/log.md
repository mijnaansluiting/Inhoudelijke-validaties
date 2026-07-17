# Update Log

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
