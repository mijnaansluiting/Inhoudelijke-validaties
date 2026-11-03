#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
RULES=$(scripts/versions.sh rules "$VERSION") || exit 1


OUT_DIR=$VERSION/rule_validation_reports

while read -r RULE SOURCE; do
    TEST_DATA_DIR=$SOURCE/test/rule_validation_data/$RULE
    for TEST_DIR in $TEST_DATA_DIR/*; do
        TEST_TYPE=$(basename "$TEST_DIR")
        echo "Validating $TEST_TYPE test data for rule $RULE"
        mkdir -p $OUT_DIR/$RULE/$TEST_TYPE
        java -jar saxon-he.jar -xsl:$VERSION/rules/transpiled_phases/$RULE.xsl -s:$TEST_DATA_DIR/$TEST_TYPE/ -o:$OUT_DIR/$RULE/$TEST_TYPE/
    done
done <<< "$RULES"
