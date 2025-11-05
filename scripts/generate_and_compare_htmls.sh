#!/bin/bash

java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:doc/NLCSValidatieRegels.xml -o:doc/NLCSValidatieRegels.html
if ! git diff --quiet doc/NLCSValidatieRegels.html; then
    echo "::error title=Uncommitted changes detected in NLCSValidatieRegels.html::NLCSValidatieRegels.html is not in line with NLCSValidatieRegels.xml. Please run the following command locally and commit the changes: java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:doc/NLCSValidatieRegels.xml -o:doc/NLCSValidatieRegels.html"
    exit 1
fi
