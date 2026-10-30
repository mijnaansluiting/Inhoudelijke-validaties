#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

RULES=$(scripts/versions.sh rules "$VERSION") || exit 1

declare -A RULES_SOURCE

while read -r RULE SOURCE; do
    RULES_SOURCE[$RULE]=$SOURCE
done <<< "$RULES"

RULE_VALIDATION_REPORTS_DIR=rule_validation_reports/$VERSION
VALIDATION_TEST_RESULTS_DIR=validation_test_results/$VERSION

# For every rule validation reports, generates a file containing PASS or FAIL
# based on the test type (passing/failing) and the amount of <assert-failed> elements
for RULE_DIR in $RULE_VALIDATION_REPORTS_DIR/*; do
    RULE=$(basename "$RULE_DIR")
    for TEST_DIR in $RULE_DIR/*; do
        TEST_TYPE=$(basename "$TEST_DIR")
        mkdir -p "$VALIDATION_TEST_RESULTS_DIR/$RULE/$TEST_TYPE"

        echo "Checking $TEST_TYPE validation reports for rule $RULE"
        java -jar saxon-he.jar -xsl:transformations/check_validation_reports.xsl -s:$RULE_VALIDATION_REPORTS_DIR/$RULE/$TEST_TYPE/ -o:$VALIDATION_TEST_RESULTS_DIR/$RULE/$TEST_TYPE/
    done
done

{
    echo "## Validation Failures"
    echo ""
    echo "| Message | File | Link |"
    echo "| ------- | ---- | ---- |"
} >> $GITHUB_STEP_SUMMARY

ALL_RULES_PASSING=true

# Report every non-PASS file
while IFS= read -r -d '' FILE; do
    if [[ "$(cat "$FILE")" != "PASS" ]]; then
        ALL_RULES_PASSING=false

        TEST_TYPE=$(echo "$FILE" | cut -d'/' -f4)
        RULE=$(echo "$FILE" | cut -d'/' -f3)
        SOURCE=$RULES_SOURCE[$RULE]
        if [[ "$TEST_TYPE" == "passing" ]]; then
            MESSAGE="Failed asserts found, expected none"
        else
            MESSAGE="Expected failed asserts, found none"
        fi

        RULE_VALIDATION_DATA_PATH="${FILE/validation_test_results\/$VERSION\//test/rule_validation_data/$SOURCE}"
        RULE_VALIDATION_DATA_PATH="${RULE_VALIDATION_DATA_PATH/%.txt/.xml}"

        echo "| $MESSAGE | $RULE_VALIDATION_DATA_PATH | [View file](https://github.com/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA}/$RULE_VALIDATION_DATA_PATH) |" >> $GITHUB_STEP_SUMMARY
    fi
done < <(find "$VALIDATION_TEST_RESULTS_DIR" -type f -print0)

if [[ "$ALL_RULES_PASSING" != true ]]; then
    {
        echo
        echo "**For more detailed information, see the artifact below for the complete rule validation reports**"
    } >> $GITHUB_STEP_SUMMARY
    exit 1
fi
