#!/bin/bash

version="v12"

test_data_dir=test/rule_validation_data/$version
out_dir=assets

for rule_dir in $test_data_dir/*; do
    rule=$(basename "$rule_dir")
    for test_dir in $rule_dir/*; do
        test_type=$(basename "$test_dir")
        echo "$version/$rule/$test_type"
        mkdir -p $out_dir/$rule/$test_type
        java -jar saxon-he.jar -xsl:transformations/visualize_test_data.xsl -s:$test_data_dir/$rule/$test_type/ -o:$out_dir/$rule/$test_type/
        for test_file in "$out_dir/$rule/$test_type/"*; do
            test_name=$(basename "$test_file")
            if grep -q viewBox=\"\" "$test_file"; then
               rm $test_file
            fi
        done
    done
done

find $out_dir/ -type d -empty -delete
find $out_dir/ -depth -name "*.xml" -exec sh -c 'mv "$1" "${1%.xml}.svg"' _ {} \;