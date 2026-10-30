#!/bin/bash

version=$(scripts/versions.sh resolve "$1") || exit 1
out_dir=dist

# main.xsl includes ../../xsl_functions/, so it sits two folders below src/, like the
# compiled schemas in validation_schemas/<version>/transpiled_phases/
mkdir -p $out_dir/src/base/$version
mkdir -p $out_dir/doc/$version
mkdir -p $out_dir/localization

# Copy base schema
cp validation_schemas/$version/transpiled_phases/main_scope_checks.xsl $out_dir/src/base/$version/main.xsl

# Copy XSL functions
cp -a validation_schemas/xsl_functions/. $out_dir/src/xsl_functions

# Copy config files
cp -a configuration/. $out_dir/configuration/
# rule_scope_functions.xsl reads doc/<version>/NLCSValidatieRegels.xml
cp doc/$version/NLCSValidatieRegels.xml $out_dir/doc/$version/

# Copy localization messages
cp -a localization/* $out_dir/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
