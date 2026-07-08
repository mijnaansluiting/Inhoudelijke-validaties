# Decisions

Tacit "why" behind past changes, recovered from git/PR history — not
otherwise derivable from reading the code alone.

* [Bestand-category rules are severity-scopeless](scope-bound-vs-scopeless-rules.md) - Why file-level rules like R.1/R.2/R.35/R.40 always report severity "Fout" instead of being matched against a scope.
* [Rounding geometric comparisons to millimeters](distance-precision-rounding.md) - Why distance/touch checks round to a configured decimal precision instead of comparing raw floating-point doubles.
