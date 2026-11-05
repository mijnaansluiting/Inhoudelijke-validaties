#!/bin/bash

# Bundles every version into a single zip.
# Expects <version>/rules/transpiled_phases/main_scope_checks.xsl to be compiled for every version.
OUT_DIR=dist
ZIP=nlcspp_inhoudelijke_validaties.zip

VERSIONS=$(scripts/versions.sh list)
[[ -n "$VERSIONS" ]] || { echo "bundle.sh: no versions registered" >&2; exit 1; }

rm -rf "$OUT_DIR" "$ZIP"

# dist mirrors the repository layout, so the relative paths in the compiled schema
# (../../xsl_functions/ or ../../../<version>/xsl_functions/), in xsl_functions
# (../../configuration/, ../../<version>/doc/) resolve the same way as in the repository
mkdir -p $OUT_DIR/configuration $OUT_DIR/localization

for VERSION in $VERSIONS; do
    SCHEMA=$VERSION/rules/transpiled_phases/main_scope_checks.xsl
    [[ -f "$SCHEMA" ]] || { echo "bundle.sh: $SCHEMA is missing, compile it first" >&2; exit 1; }

    mkdir -p $OUT_DIR/$VERSION/rules/transpiled_phases $OUT_DIR/$VERSION/doc

    # Copy compiled schema
    cp $SCHEMA $OUT_DIR/$VERSION/rules/transpiled_phases/

    # Copy XSL functions of every version main.sch includes them from (its own, or one it inherits from)
    for FUNCTIONS_VERSION in $(sed -n "s#.*<xsl:include href=\"\.\./\.\./\.\./\(v[^/]*\)/xsl_functions/.*#\1#p" $VERSION/rules/main.sch | sort -u); do
        mkdir -p $OUT_DIR/$FUNCTIONS_VERSION
        cp -a $FUNCTIONS_VERSION/xsl_functions $OUT_DIR/$FUNCTIONS_VERSION/
    done
    if grep -q '<xsl:include href="\.\./\.\./xsl_functions/' $VERSION/rules/main.sch; then
        cp -a $VERSION/xsl_functions $OUT_DIR/$VERSION/
    fi

    # rule_scope_functions.xsl reads <version>/doc/NLCSValidatieRegels.xml
    cp $VERSION/doc/NLCSValidatieRegels.xml $OUT_DIR/$VERSION/doc/
done

# Copy config files
cp -a configuration/. $OUT_DIR/configuration/

# Copy localization messages
cp -a localization/* $OUT_DIR/localization/

# Zip release
zip -r $ZIP $OUT_DIR
