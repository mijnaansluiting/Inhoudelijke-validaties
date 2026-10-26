#!/bin/bash

source "$(dirname "$0")/version.sh"
out_dir=assets
rm -rf $out_dir/*

for version in $(list_versions); do
    versioned_dir=$out_dir/$version
    test_data_dir=test/rule_validation_data/$version
    for rule_dir in $test_data_dir/*; do
        rule=$(basename "$rule_dir")
        for test_dir in $rule_dir/*; do
            test_type=$(basename "$test_dir")
            echo "$version/$rule/$test_type"
            mkdir -p $versioned_dir/$rule/$test_type
            # Generate SVGs as .xml files
            java -jar saxon-he.jar -xsl:transformations/visualize_test_data.xsl -s:$test_data_dir/$rule/$test_type/ -o:$versioned_dir/$rule/$test_type/
            for test_file in "$versioned_dir/$rule/$test_type/"*; do
                test_name=$(basename "$test_file")
                # viewBox is empty when there are no geometries, so remove file
                if grep -q viewBox=\"\" "$test_file"; then
                rm $test_file
                fi
            done
        done
    done
done

# Remove emtpy dirs
find $out_dir/ -type d -empty -delete
# Rename .xml to .svg
find $out_dir/ -depth -name "*.xml" -exec sh -c 'mv "$1" "${1%.xml}.svg"' _ {} \;

if [[ -n $(git status --porcelain assets/) ]]; then
    changed_versions=$(git status --porcelain assets/ | awk '{print $2}' | cut
    -d/ -f2 | sort -u)
    echo "::error title=Uncommitted changes detected in assets::Test data SVGs
    are not in line with the test data for: $(echo $changed_versions). Please run
    the following command locally and commit the changes: ${0}"
    exit 1
  fi
