#!/bin/bash

all_test_data_valid=true
for version in $(scripts/versions.sh list); do
    xsd_version=$(scripts/versions.sh xsd "$version")
    keuzelijst=xsd/$xsd_version/NLCS_Netbeheer_Keuzelijst.xsd

    # Test data must declare the NLCS++ version its rule-set version targets, since VersieNummer is what selects the version
    while IFS= read -r test_file; do
        echo "::error file=$test_file::$test_file must declare VersieNummer=\"$xsd_version\" on its root element"
        all_test_data_valid=false
    done < <(grep -rLF --include=*.xml "VersieNummer=\"$xsd_version\"" "test/rule_validation_data/$version")

    if ! java -jar xerces-cli.jar "$keuzelijst" "test/rule_validation_data/$version"; then
        all_test_data_valid=false
    fi
done

if [[ "$all_test_data_valid" != true ]]; then
    exit 1
fi
