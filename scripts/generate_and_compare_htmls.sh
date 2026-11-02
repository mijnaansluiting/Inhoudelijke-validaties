#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1

DOC_DIR=doc/$VERSION

java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:$DOC_DIR/NLCSValidatieRegels.xml -o:$DOC_DIR/NLCSValidatieRegels.html
if ! git diff --quiet $DOC_DIR/NLCSValidatieRegels.html; then
    echo "::error title=Uncommitted changes detected in $DOC_DIR/NLCSValidatieRegels.html::$DOC_DIR/NLCSValidatieRegels.html is not in line with $DOC_DIR/NLCSValidatieRegels.xml. Please run the following command locally and commit the changes: java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:$DOC_DIR/NLCSValidatieRegels.xml -o:$DOC_DIR/NLCSValidatieRegels.html"
    exit 1
fi
