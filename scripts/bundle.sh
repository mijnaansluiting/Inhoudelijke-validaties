#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
OUT_DIR=dist

# main.xsl includes ../../xsl_functions/, so it sits two folders below src/, like the
# compiled schemas in validation_schemas/<version>/transpiled_phases/
mkdir -p $OUT_DIR/src/base/$VERSION
mkdir -p $OUT_DIR/doc/$VERSION
mkdir -p $OUT_DIR/localization

# Copy base schema
cp rules/$VERSION/transpiled_phases/main_scope_checks.xsl $OUT_DIR/src/base/$VERSION/main.xsl

# Copy XSL functions
cp -a rules/xsl_functions/. $OUT_DIR/src/xsl_functions

# Copy config files
cp -a configuration/. $OUT_DIR/configuration/
# rule_scope_functions.xsl reads doc/<version>/NLCSValidatieRegels.xml
cp doc/$VERSION/NLCSValidatieRegels.xml $OUT_DIR/doc/$VERSION/

# Copy localization messages
cp -a localization/* $OUT_DIR/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
