#!/bin/bash

version=v2026.1.0

schema_dir=validation_schemas/$version

mkdir -p $schema_dir/abstract_patterns_scope_checks

for abstract_pattern_dir in $schema_dir/abstract_patterns/*; do
    pattern_type=$(basename "$abstract_pattern_dir")
    echo Adding scope checks to $pattern_type abstract patterns...

    mkdir -p $schema_dir/abstract_patterns_scope_checks/$pattern_type
    java -jar saxon-he.jar -xsl:transformations/abstract_patterns_scope_checks.xsl -s:$schema_dir/abstract_patterns/$pattern_type/ -o:$schema_dir/abstract_patterns_scope_checks/$pattern_type
done

echo Updating Schematron base to importing updated abstract patterns...
java -jar saxon-he.jar -xsl:transformations/base_scope_checks.xsl -s:validation_schemas/$version/main.sch -o:validation_schemas/base_scope_checks/main.sch