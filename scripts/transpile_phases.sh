#!/bin/bash

version=$(scripts/versions.sh resolve "$1") || exit 1

rules=$(scripts/versions.sh rules "$version") || exit 1


for phase in $(awk '{ print $1 }' <<< "$rules"); do
    echo "Transpiling schema for phase $phase"
    java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl -s:validation_schemas/$version/main.sch -o:validation_schemas/phases_transpiled_$version/$phase.xsl phase=$phase
done
