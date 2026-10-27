#!/bin/bash

version=$(scripts/versions.sh resolve "${1:-$(scripts/versions.sh latest)}") || exit 1

doc_dir=doc/$version

java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:$doc_dir/NLCSValidatieRegels.xml -o:$doc_dir/NLCSValidatieRegels.html
if ! git diff --quiet $doc_dir/NLCSValidatieRegels.html; then
    echo "::error title=Uncommitted changes detected in $doc_dir/NLCSValidatieRegels.html::$doc_dir/NLCSValidatieRegels.html is not in line with $doc_dir/NLCSValidatieRegels.xml. Please run the following command locally and commit the changes: java -jar saxon-he.jar -xsl:doc/NLCSValidatieRegels.xsl -s:$doc_dir/NLCSValidatieRegels.xml -o:$doc_dir/NLCSValidatieRegels.html"
    exit 1
fi
