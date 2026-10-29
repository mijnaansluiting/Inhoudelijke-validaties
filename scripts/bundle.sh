#!/bin/bash

version=$(scripts/versions.sh resolve "$1") || exit 1
out_dir=dist

mkdir -p $out_dir/src/base
mkdir -p $out_dir/doc
mkdir -p $out_dir/localization

# Copy base schema
cp validation_schemas/$version/main_scope_checks.xsl $out_dir/src/base/main.xsl

# Copy XSL functions
cp -a validation_schemas/xsl_functions/. $out_dir/src/xsl_functions

# Copy config files
cp -a configuration/. $out_dir/configuration/
cp doc/$version/NLCSValidatieRegels.xml $out_dir/doc/

# Copy localization messages
cp -a localization/* $out_dir/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
