#!/bin/bash

version=$(scripts/versions.sh resolve "${1:-$(scripts/versions.sh latest)}") || exit 1

rules=$(scripts/versions.sh rules "$version") || exit 1

declare -A rules_source

while read -r rule source; do
    rules_source[$rule]=$source
done <<< "$rules"

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

        test_type=$(echo "$file" | cut -d'/' -f4)
        rule=$(echo "$file" | cut -d'/' -f3)
        source=$rules_source[$rule]
        if [[ "$test_type" == "passing" ]]; then
            message="Failed asserts found, expected none"
        else
            message="Expected failed asserts, found none"
        fi

        rule_validation_data_path="${file/validation_test_results\/$version\//test/rule_validation_data/$source}"
        rule_validation_data_path="${rule_validation_data_path/%.txt/.xml}"

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
