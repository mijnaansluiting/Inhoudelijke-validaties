#!/bin/bash

version=$(scripts/versions.sh resolve "$1") || exit 1
rules=$(scripts/versions.sh rules "$version") || exit 1


out_dir=rule_validation_reports/$version

while read -r rule source; do
    test_data_dir=test/rule_validation_data/$source/$rule
    for test_dir in $test_data_dir/*; do
        test_type=$(basename "$test_dir")
        echo "Validating $test_type test data for rule $rule"
        mkdir -p $out_dir/$rule/$test_type
        java -jar saxon-he.jar -xsl:validation_schemas/phases_transpiled_$version/$rule.xsl -s:$test_data_dir/$test_type/ -o:$out_dir/$rule/$test_type/
    done
done <<< "$rules"
