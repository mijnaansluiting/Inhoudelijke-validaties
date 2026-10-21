#!/bin/bash

source "$(dirname "$0")/version.sh"
version=$(resolve_version "$1") || exit 1

for dir in test/rule_validation_data/$version/*; do
    phase=$(basename "$dir")
    echo "Transpiling schema for phase $phase"
    java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl -s:validation_schemas/$version/main.sch -o:validation_schemas/phases_transpiled/$phase.xsl phase=$phase
done
