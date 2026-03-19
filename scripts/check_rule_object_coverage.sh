#!/bin/bash

version="v12"

{
    echo "## Object coverage"
    echo
    echo "| Rule | Expected | Found | Missing |"
    echo "| ---- | -------- | ----- | ------- |"
} >> $GITHUB_STEP_SUMMARY

all_rules_covered_correctly=true

for dir in rule_validation_reports/$version/*; do
    rule_number=$(basename "$dir")
    echo "Checking rule object coverage for $rule_number"
    output=$(java -jar saxon-he.jar -xsl:transformations/check_object_coverage.xsl -s:doc/NLCSValidatieRegels.xml rule_number=$rule_number)

    while IFS=',' read -r -a markdown_and_validity; do
        validity=${markdown_and_validity[1]}
        if [[ $validity == false ]]; then
            markdown=${markdown_and_validity[0]}
            echo $markdown >> $GITHUB_STEP_SUMMARY
            all_rules_covered_correctly=false
        fi
    done <<< "$output"
done

if [[ $all_rules_covered_correctly == false ]]; then
    summary_url="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
    echo "::error title=Objects incorrectly covered::Some objects have been incorrectly covered. See the summary for more details: $summary_url"
    exit 1
fi