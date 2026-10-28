#!/bin/bash


all_test_data_valid=true
for version in $(scripts/versions.sh list); do
    xsd_version=$(scripts/versions.sh xsd "$version")
    keuzelijst=xsd/$xsd_version/NLCS_Netbeheer_Keuzelijst.xsd

    if ! java -jar xerces-cli.jar "$keuzelijst" "test/rule_validation_data/$version"; then
        all_test_data_valid=false
    fi
done

if [[ "$all_test_data_valid" != true ]]; then
   exit 1
fi
