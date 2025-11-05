#!/bin/bash

version=v12


mkdir -p validation_schemas/abstract_patterns_scope_checks/$version

for abstract_pattern_dir in validation_schemas/abstract_patterns/$version/*; do
    pattern_type=$(basename "$abstract_pattern_dir")
    echo Adding scope checks to $pattern_type abstract patterns...

    mkdir -p validation_schemas/abstract_patterns_scope_checks/$version/$pattern_type
    java -jar saxon-he.jar -xsl:transformations/abstract_patterns_scope_checks.xsl -s:validation_schemas/abstract_patterns/$version/$pattern_type/ -o:validation_schemas/abstract_patterns_scope_checks/$version/$pattern_type
done

echo Updating Schematron base to importing updated abstract patterns...
java -jar saxon-he.jar -xsl:transformations/base_scope_checks.xsl -s:validation_schemas/base/$version.sch -o:validation_schemas/base_scope_checks/$version.sch
