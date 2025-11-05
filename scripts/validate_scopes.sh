#!/bin/bash

version=v12

java -jar saxon-he.jar -xsl:transformations/generate_scoped_objects.xsl -s:test/scope_validation_data/$version/scope_template.xml

in_dir=scoped_objects
out_dir=scoped_objects_reports

{
    echo "## Onvolledige of onjuiste scopedekking"
    echo
    echo "| Scope | Tekening type | Status | Bedrijfstoestand | Verwacht | Gevonden | Missend | Niet verwacht |"
    echo "| ----- | ------------- | ------ | ---------------- | -------- | -------- | ------- | ------------- |"
} >> $GITHUB_STEP_SUMMARY

scopes_fully_covered=true

for scope_dir in "$in_dir"/*; do
    scope=$(basename "$scope_dir")
    for tekening_type_dir in "$scope_dir"/*; do
        tekening_type=$(basename "$tekening_type_dir")
        for status_dir in "$tekening_type_dir"/*; do
            status=$(basename "$status_dir")
            for bedrijfstoestand_file in "$status_dir"/*; do
                bedrijfstoestand=$(basename "$bedrijfstoestand_file" .xml)

                file_out_dir=$out_dir/$scope/$tekening_type/$status
                mkdir -p "$file_out_dir"
                out_file=$file_out_dir/$bedrijfstoestand.svrl.xml

                echo Validating $scope "->" $tekening_type "->" $status "->" $bedrijfstoestand
                java -jar saxon-he.jar -xsl:validation_schemas/base_scope_checks/v12.xsl -s:"$bedrijfstoestand_file" -o:"$out_file"

                validation_report_analysis="$(java -jar saxon-he.jar -xsl:transformations/check_scope_coverage.xsl -s:"$out_file" scope_name="$scope")"

                while IFS='=' read -r key value; do
                    case "$key" in
                        expected)   expected=($value) ;;
                        found)      found=($value) ;;
                        missing)    missing=($value) ;;
                        unexpected) unexpected=($value) ;;
                    esac
                done <<< "$validation_report_analysis"


                if [[ ${#missing[@]} -ne 0 || ${#unexpected[@]} -ne 0 ]]; then
                    echo "| $scope | $tekening_type | $status | $bedrijfstoestand | ${expected[*]} | ${found[*]} | ${missing[*]} | ${unexpected[*]} |" >> $GITHUB_STEP_SUMMARY
                    scopes_fully_covered=false
                fi
            done
        done
    done
done

if [ "$scopes_fully_covered" != true ]; then
    exit 1
fi
