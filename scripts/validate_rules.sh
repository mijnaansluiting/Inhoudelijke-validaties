#!/bin/bash

version="v12"

test_data_dir=test/rule_validation_data/$version
out_dir=rule_validation_reports/$version

for rule_dir in $test_data_dir/*; do
    rule=$(basename "$rule_dir")
    for test_dir in $rule_dir/*; do
        test_type=$(basename "$test_dir")
        echo "Validating $test_type test data for rule $rule"
        mkdir -p $out_dir/$rule/$test_type
        java -jar saxon-he.jar -xsl:validation_schemas/phases_transpiled/$rule.xsl -s:$test_data_dir/$rule/$test_type/ -o:$out_dir/$rule/$test_type/
    done
done
