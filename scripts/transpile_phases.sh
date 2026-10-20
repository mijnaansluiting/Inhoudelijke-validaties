#!/bin/bash

version="v2026.1.0"
nlcspp_version="v12"

for dir in test/rule_validation_data/$version/*; do
    phase=$(basename "$dir")
    echo "Transpiling schema for phase $phase"
    java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl -s:validation_schemas/$version/$nlcspp_version.sch -o:validation_schemas/phases_transpiled/$phase.xsl phase=$phase
done
