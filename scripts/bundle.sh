#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
OUT_DIR=dist

# dist mirrors the repository layout, so the relative paths in the compiled schema
# (../../xsl_functions/ or ../../../<version>/xsl_functions/) and in xsl_functions
# (../../configuration/, ../../<version>/doc/) resolve the same way as in the repository
mkdir -p $OUT_DIR/$VERSION/rules/transpiled_phases
mkdir -p $OUT_DIR/$VERSION/doc
mkdir -p $OUT_DIR/localization

# Copy base schema
cp $VERSION/rules/transpiled_phases/main_scope_checks.xsl $OUT_DIR/$VERSION/rules/transpiled_phases/

# Copy XSL functions of every version main.sch includes them from (its own, or one it inherits from)
for FUNCTIONS_VERSION in $(sed -n "s#.*<xsl:include href=\"\.\./\.\./\.\./\(v[^/]*\)/xsl_functions/.*#\1#p" $VERSION/rules/main.sch | sort -u); do
    mkdir -p $OUT_DIR/$FUNCTIONS_VERSION
    cp -a $FUNCTIONS_VERSION/xsl_functions $OUT_DIR/$FUNCTIONS_VERSION/
done
if grep -q '<xsl:include href="\.\./\.\./xsl_functions/' $VERSION/rules/main.sch; then
    cp -a $VERSION/xsl_functions $OUT_DIR/$VERSION/
fi

# Copy config files
cp -a configuration/. $OUT_DIR/configuration/
# rule_scope_functions.xsl reads <version>/doc/NLCSValidatieRegels.xml
cp $VERSION/doc/NLCSValidatieRegels.xml $OUT_DIR/$VERSION/doc/

# Copy localization messages
cp -a localization/* $OUT_DIR/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
