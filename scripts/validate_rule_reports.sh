#!/bin/bash

version="v12"

rule_validation_reports_dir=rule_validation_reports/$version
validation_test_results_dir=validation_test_results/$version

# For every rule validation reports, generates a file containing PASS or FAIL
# based on the test type (passing/failing) and the amount of <assert-failed> elements
for rule_dir in $rule_validation_reports_dir/*; do
    rule=$(basename "$rule_dir")
    for test_dir in $rule_dir/*; do
        test_type=$(basename "$test_dir")
        mkdir -p "$validation_test_results_dir/$rule/$test_type"

        echo "Checking $test_type validation reports for rule $rule"
        java -jar saxon-he.jar -xsl:transformations/check_validation_reports.xsl -s:$rule_validation_reports_dir/$rule/$test_type/ -o:$validation_test_results_dir/$rule/$test_type/
    done
done

{
    echo "## Validation Failures"
    echo ""
    echo "| Message | File | Link |"
    echo "| ------- | ---- | ---- |"
} >> $GITHUB_STEP_SUMMARY

all_rules_passing=true

# Report every non-PASS file
while IFS= read -r -d '' file; do
    if [[ "$(cat "$file")" != "PASS" ]]; then
        all_rules_passing=false

        rule_validation_data_path="${file/validation_test_results\//test/rule_validation_data/}"
        rule_validation_data_path="${rule_validation_data_path/%.txt/.xml}"

        test_type=$(echo "$file" | cut -d'/' -f4)
        if [[ "$test_type" == "passing" ]]; then
            message="Failed asserts found, expected none"
        else
            message="Expected failed asserts, found none"
        fi

        echo "| $message | $rule_validation_data_path | [View file](https://github.com/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA}/$rule_validation_data_path) |" >> $GITHUB_STEP_SUMMARY
    fi
done < <(find "$validation_test_results_dir" -type f -print0)

if [[ "$all_rules_passing" != true ]]; then
    {
        echo
        echo "**For more detailed information, see the artifact below for the complete rule validation reports**"
    } >> $GITHUB_STEP_SUMMARY
    exit 1
fi
