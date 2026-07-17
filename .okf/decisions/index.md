# Decisions

Tacit "why" behind past changes, recovered from git/PR history — not
otherwise derivable from reading the code alone.

* [Bestand-category rules are severity-scopeless](./scope-bound-vs-scopeless-rules) - Why file-level rules like R.1/R.2/R.35/R.40 always report severity "Fout" instead of being matched against a scope.
* [Rounding geometric comparisons to millimeters](./distance-precision-rounding) - Why distance/touch checks round to a configured decimal precision instead of comparing raw floating-point doubles.
* [Shared connectivity index and geometry caching](./connectivity-index-and-geometry-caching) - Why R.20, R.22, R.23, R.25, R.26, and R.39 now share one precomputed touch index instead of each doing its own brute-force geometry scan.
* [Memoized geometry parsing](./geometry-parse-caching) - Why parsing a geometry's raw GML coordinate string is now cached per node, and why R.21 was the dominant remaining cost the connectivity-index fix didn't touch.
