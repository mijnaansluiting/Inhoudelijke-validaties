#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

TEST_DATA_DIR=test/rule_validation_data/$VERSION
OUT_DIR=assets

rm -rf $OUT_DIR/*

for RULE_DIR in $TEST_DATA_DIR/*; do
    RULE=$(basename "$RULE_DIR")
    for TEST_DIR in $RULE_DIR/*; do
        TEST_TYPE=$(basename "$TEST_DIR")
        echo "$VERSION/$RULE/$TEST_TYPE"
        mkdir -p $OUT_DIR/$RULE/$TEST_TYPE
        # Generate SVGs as .xml files
        java -jar saxon-he.jar -xsl:transformations/visualize_test_data.xsl -s:$TEST_DATA_DIR/$RULE/$TEST_TYPE/ -o:$OUT_DIR/$RULE/$TEST_TYPE/
        for TEST_FILE in "$OUT_DIR/$RULE/$TEST_TYPE/"*; do
            TEST_NAME=$(basename "$TEST_FILE")
            # viewBox is empty when there are no geometries, so remove file
            if grep -q viewBox=\"\" "$TEST_FILE"; then
               rm $TEST_FILE
            fi
        done
    done
done

# Remove emtpy dirs
find $OUT_DIR/ -type d -empty -delete
# Rename .xml to .svg
find $OUT_DIR/ -depth -name "*.xml" -exec sh -c 'mv "$1" "${1%.xml}.svg"' _ {} \;

# Throw error in pipeline if any of the SVGs are not up-to-date
if ! git diff --quiet assets/; then
    echo "::error title=Uncommitted changes detected in assets::Test data SVGs are not in line with the test data. Please run the following command locally and commit the changes: ${0}"
    exit 1
fi