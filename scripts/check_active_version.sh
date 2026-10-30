#!/bin/bash

# Every registered version needs a main.sch declaring its own folder name as active_version,
# a sys_config block and a rule catalog; every version folder must be registered

ALL_VERSIONS_MATCH=true

for VERSION in $(scripts/versions.sh list); do
    SCHEMA=validation_schemas/$VERSION/main.sch
    if [[ ! -f "$SCHEMA" ]]; then
        echo "::error file=configuration/versions.xml::Version $VERSION is registered, but $SCHEMA does not exist"
        ALL_VERSIONS_MATCH=false
    elif ! grep -q "<let name=\"active_version\" value=\"'$VERSION'\"/>" "$SCHEMA"; then
        echo "::error file=$SCHEMA::$SCHEMA must declare <let name=\"active_version\" value=\"'$VERSION'\"/>"
        ALL_VERSIONS_MATCH=false
    fi
    if ! grep -q "<version id=\"$VERSION\">" configuration/sys_config.xml; then
        echo "::error file=configuration/sys_config.xml::configuration/sys_config.xml has no <version id=\"$VERSION\"> block"
        ALL_VERSIONS_MATCH=false
    fi
    if [[ ! -f doc/$VERSION/NLCSValidatieRegels.xml ]]; then
        echo "::error file=configuration/versions.xml::Version $VERSION is registered, but doc/$VERSION/NLCSValidatieRegels.xml does not exist"
        ALL_VERSIONS_MATCH=false
    fi
done

for SCHEMA_DIR in validation_schemas/v*/; do
    VERSION=$(basename "$SCHEMA_DIR")
    if ! scripts/versions.sh list | grep -qx "$VERSION"; then
        echo "::error file=configuration/versions.xml::$SCHEMA_DIR is not registered in configuration/versions.xml"
        ALL_VERSIONS_MATCH=false
    fi
done

if [[ "$ALL_VERSIONS_MATCH" != true ]]; then
    exit 1
fi

echo "All versions have a matching active_version, sys_config block and rule catalog."
