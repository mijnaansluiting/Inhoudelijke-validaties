#!/bin/bash

source "$(dirname "$0")/version.sh"
version=$(resolve_version "$1") || exit 1

schema_dir=validation_schemas/$version

mkdir -p $schema_dir/abstract_patterns_scope_checks

for abstract_pattern_dir in $schema_dir/abstract_patterns/*; do
    pattern_type=$(basename "$abstract_pattern_dir")
    echo Adding scope checks to $pattern_type abstract patterns...

    mkdir -p $schema_dir/abstract_patterns_scope_checks/$pattern_type
    java -jar saxon-he.jar -xsl:transformations/abstract_patterns_scope_checks.xsl -s:$schema_dir/abstract_patterns/$pattern_type/ -o:$schema_dir/abstract_patterns_scope_checks/$pattern_type
done

echo Updating Schematron base to importing updated abstract patterns...
java -jar saxon-he.jar -xsl:transformations/base_scope_checks.xsl -s:$schema_dir/main.sch -o:$schema_dir/main_scope_checks.sch