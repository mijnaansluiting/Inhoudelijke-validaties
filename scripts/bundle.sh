#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
OUT_DIR=dist

# dist mirrors the repository layout, so the relative paths in the compiled schema
# (../../../xsl_functions/) and in xsl_functions (../configuration/, ../<version>/doc/)
# resolve the same way as in the repository
mkdir -p $OUT_DIR/$VERSION/rules/transpiled_phases
mkdir -p $OUT_DIR/$VERSION/doc
mkdir -p $OUT_DIR/localization

# Copy base schema
cp $VERSION/rules/transpiled_phases/main_scope_checks.xsl $OUT_DIR/$VERSION/rules/transpiled_phases/

# Copy XSL functions
cp -a xsl_functions/. $OUT_DIR/xsl_functions

# Copy config files
cp -a configuration/. $OUT_DIR/configuration/
# rule_scope_functions.xsl reads <version>/doc/NLCSValidatieRegels.xml
cp $VERSION/doc/NLCSValidatieRegels.xml $OUT_DIR/$VERSION/doc/

# Copy localization messages
cp -a localization/* $OUT_DIR/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
