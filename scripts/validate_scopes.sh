#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

java -jar saxon-he.jar -xsl:transformations/generate_scoped_objects.xsl -s:test/scope_validation_data/$VERSION/scope_template.xml version=$VERSION

IN_DIR=scoped_objects
OUT_DIR=scoped_objects_reports

{
    echo "## Onvolledige of onjuiste scopedekking"
    echo
    echo "| Scope | Tekening type | Status | Bedrijfstoestand | Verwacht | Gevonden | Missend | Niet verwacht |"
    echo "| ----- | ------------- | ------ | ---------------- | -------- | -------- | ------- | ------------- |"
} >> $GITHUB_STEP_SUMMARY

SCOPES_FULLY_COVERED=true

for SCOPE_DIR in "$IN_DIR"/*; do
    SCOPE=$(basename "$SCOPE_DIR")
    for TEKENING_TYPE_DIR in "$SCOPE_DIR"/*; do
        TEKENING_TYPE=$(basename "$TEKENING_TYPE_DIR")
        for STATUS_DIR in "$TEKENING_TYPE_DIR"/*; do
            STATUS=$(basename "$STATUS_DIR")
            for BEDRIJFSTOESTAND_FILE in "$STATUS_DIR"/*; do
                BEDRIJFSTOESTAND=$(basename "$BEDRIJFSTOESTAND_FILE" .xml)

                FILE_OUT_DIR=$OUT_DIR/$SCOPE/$TEKENING_TYPE/$STATUS
                mkdir -p "$FILE_OUT_DIR"
                OUT_FILE=$FILE_OUT_DIR/$BEDRIJFSTOESTAND.svrl.xml

                echo Validating $SCOPE "->" $TEKENING_TYPE "->" $STATUS "->" $BEDRIJFSTOESTAND
                java -jar saxon-he.jar -xsl:validation_schemas/$VERSION/transpiled_phases/main_scope_checks.xsl -s:"$BEDRIJFSTOESTAND_FILE" -o:"$OUT_FILE"

                VALIDATION_REPORT_ANALYSIS="$(java -jar saxon-he.jar -xsl:transformations/check_scope_coverage.xsl -s:"$OUT_FILE" scope_name="$SCOPE" version="$VERSION")"

                while IFS='=' read -r KEY VALUE; do
                    case "$KEY" in
                        expected)   EXPECTED=($VALUE) ;;
                        found)      FOUND=($VALUE) ;;
                        missing)    MISSING=($VALUE) ;;
                        unexpected) UNEXPECTED=($VALUE) ;;
                    esac
                done <<< "$VALIDATION_REPORT_ANALYSIS"


                if [[ ${#MISSING[@]} -ne 0 || ${#UNEXPECTED[@]} -ne 0 ]]; then
                    echo "| $SCOPE | $TEKENING_TYPE | $STATUS | $BEDRIJFSTOESTAND | ${EXPECTED[*]} | ${FOUND[*]} | ${MISSING[*]} | ${UNEXPECTED[*]} |" >> $GITHUB_STEP_SUMMARY
                    SCOPES_FULLY_COVERED=false
                fi
            done
        done
    done
done

if [ "$SCOPES_FULLY_COVERED" != true ]; then
    exit 1
fi
