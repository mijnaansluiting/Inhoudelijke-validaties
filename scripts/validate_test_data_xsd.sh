#!/bin/bash

ALL_TEST_DATA_VALID=true
for VERSION in $(scripts/versions.sh list); do
    XSD_VERSION=$(scripts/versions.sh xsd "$VERSION")
    KEUZELIJST=schemas/$XSD_VERSION/NLCS_Netbeheer_Keuzelijst.xsd

    # Test data must declare the NLCS++ version its rule-set version targets, since VersieNummer is what selects the version
    while IFS= read -r TEST_FILE; do
        echo "::error file=$TEST_FILE::$TEST_FILE must declare VersieNummer=\"$XSD_VERSION\" on its root element"
        ALL_TEST_DATA_VALID=false
    done < <(grep -rLF --include=*.xml "VersieNummer=\"$XSD_VERSION\"" "test/rule_validation_data/$VERSION")

    if ! java -jar xerces-cli.jar "$KEUZELIJST" "test/rule_validation_data/$VERSION"; then
        ALL_TEST_DATA_VALID=false
    fi
done

if [[ "$ALL_TEST_DATA_VALID" != true ]]; then
    exit 1
fi
