#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

RULES=$(scripts/versions.sh rules "$VERSION") || exit 1


for PHASE in $(awk '{ print $1 }' <<< "$RULES"); do
    echo "Transpiling schema for phase $PHASE"
    java -jar saxon-he.jar -xsl:wrappers/transpile_phase_wrapper.xsl -s:validation_schemas/$VERSION/main.sch -o:validation_schemas/$VERSION/transpiled_phases/$PHASE.xsl phase=$PHASE
done
