#!/bin/bash

# Every registered version needs a main.sch declaring its own folder name as active_version,
# a sys_config block and a rule catalog; every version folder must be registered

all_versions_match=true

for version in $(scripts/versions.sh list); do
    schema=validation_schemas/$version/main.sch
    if [[ ! -f "$schema" ]]; then
        echo "::error file=configuration/versions.xml::Version $version is registered, but $schema does not exist"
        all_versions_match=false
    elif ! grep -q "<let name=\"active_version\" value=\"'$version'\"/>" "$schema"; then
        echo "::error file=$schema::$schema must declare <let name=\"active_version\" value=\"'$version'\"/>"
        all_versions_match=false
    fi
    if ! grep -q "<version id=\"$version\">" configuration/sys_config.xml; then
        echo "::error file=configuration/sys_config.xml::configuration/sys_config.xml has no <version id=\"$version\"> block"
        all_versions_match=false
    fi
    if [[ ! -f doc/$version/NLCSValidatieRegels.xml ]]; then
        echo "::error file=configuration/versions.xml::Version $version is registered, but doc/$version/NLCSValidatieRegels.xml does not exist"
        all_versions_match=false
    fi
done

for schema_dir in validation_schemas/v*/; do
    version=$(basename "$schema_dir")
    if ! scripts/versions.sh list | grep -qx "$version"; then
        echo "::error file=configuration/versions.xml::$schema_dir is not registered in configuration/versions.xml"
        all_versions_match=false
    fi
done

if [[ "$all_versions_match" != true ]]; then
    exit 1
fi

echo "All versions have a matching active_version, sys_config block and rule catalog."
