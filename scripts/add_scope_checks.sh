#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

SCHEMA_DIR=rules/$VERSION

mkdir -p $SCHEMA_DIR/abstract_patterns_scope_checks

for ABSTRACT_PATTERN_DIR in $SCHEMA_DIR/abstract_patterns/*; do
    PATTERN_TYPE=$(basename "$ABSTRACT_PATTERN_DIR")
    echo Adding scope checks to $PATTERN_TYPE abstract patterns...

    mkdir -p $SCHEMA_DIR/abstract_patterns_scope_checks/$PATTERN_TYPE
    java -jar saxon-he.jar -xsl:transformations/abstract_patterns_scope_checks.xsl -s:$SCHEMA_DIR/abstract_patterns/$PATTERN_TYPE/ -o:$SCHEMA_DIR/abstract_patterns_scope_checks/$PATTERN_TYPE
done

echo Updating Schematron base to importing updated abstract patterns...
java -jar saxon-he.jar -xsl:transformations/base_scope_checks.xsl -s:$SCHEMA_DIR/main.sch -o:$SCHEMA_DIR/main_scope_checks.sch
