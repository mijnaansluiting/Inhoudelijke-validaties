#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

{
    echo "## Object coverage"
    echo
    echo "| Rule | Expected | Found | Missing | Extra |"
    echo "| ---- | -------- | ----- | ------- | ----- |"
} >> $GITHUB_STEP_SUMMARY

ALL_RULES_COVERED_CORRECTLY=true

for DIR in rule_validation_reports/$VERSION/*; do
    RULE_NUMBER=$(basename "$DIR")
    echo "Checking rule object coverage for $RULE_NUMBER"
    OUTPUT=$(java -jar saxon-he.jar -xsl:transformations/check_object_coverage.xsl -s:doc/$VERSION/NLCSValidatieRegels.xml rule_number=$RULE_NUMBER version=$VERSION)

    while IFS=',' read -r -a MARKDOWN_AND_VALIDITY; do
        VALIDITY=${MARKDOWN_AND_VALIDITY[1]}
        if [[ $VALIDITY == false ]]; then
            MARKDOWN=${MARKDOWN_AND_VALIDITY[0]}
            echo $MARKDOWN >> $GITHUB_STEP_SUMMARY
            ALL_RULES_COVERED_CORRECTLY=false
        fi
    done <<< "$OUTPUT"
done

if [[ $ALL_RULES_COVERED_CORRECTLY == false ]]; then
    SUMMARY_URL="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
    echo "::error title=Objects incorrectly covered::Some objects have been incorrectly covered. See the summary for more details: $SUMMARY_URL"
    exit 1
fi