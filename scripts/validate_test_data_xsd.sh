#!/bin/bash

# Validates the test data of the given version, or of every registered version when none is given
if [[ -n "$1" ]]; then
    VERSIONS=$(scripts/versions.sh resolve "$1") || exit 1
else
    VERSIONS=$(scripts/versions.sh list)
fi

ALL_TEST_DATA_VALID=true
for VERSION in $VERSIONS; do
    XSD_VERSION=$(scripts/versions.sh xsd "$VERSION")
    KEUZELIJST=schemas/$XSD_VERSION/NLCS_Netbeheer_Keuzelijst.xsd

    # Test data must declare its folder's NLCS++ version, since VersieNummer is what selects the version
    while IFS= read -r TEST_FILE; do
        echo "::error file=$TEST_FILE::$TEST_FILE must declare VersieNummer=\"$XSD_VERSION\" on its root element"
        ALL_TEST_DATA_VALID=false
    done < <(grep -rLF --include=*.xml "VersieNummer=\"$XSD_VERSION\"" "$VERSION/test/rule_validation_data")

    if ! java -jar xerces-cli.jar "$KEUZELIJST" "$VERSION/test/rule_validation_data"; then
        ALL_TEST_DATA_VALID=false
    fi
done

if [[ "$ALL_TEST_DATA_VALID" != true ]]; then
    exit 1
fi
