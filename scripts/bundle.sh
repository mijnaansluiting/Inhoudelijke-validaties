#!/bin/bash

version=v12
out_dir=dist

mkdir -p $out_dir/src/base
mkdir -p $out_dir/doc
mkdir -p $out_dir/localization

# Copy base schema
cp validation_schemas/base_scope_checks/$version.xsl $out_dir/src/base/

# Copy XSL functions
cp -a validation_schemas/xsl_functions/. $out_dir/src/xsl_functions

# Copy config files
cp -a configuration/. $out_dir/configuration/
cp doc/NLCSValidatieRegels.xml $out_dir/doc/

# Copy localization messages
cp -a localization/* $out_dir/localization/

# Zip release
zip -r nlcspp_inhoudelijke_validaties.zip dist
