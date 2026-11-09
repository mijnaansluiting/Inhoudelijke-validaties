#!/bin/bash

# Writes the GitHub Pages landing page (index.html, or the path given as $1):
# a link to <version>/doc/NLCSValidatieRegels.html for every registered version, newest first.
OUTPUT=${1:-index.html}

VERSIONS=$(scripts/versions.sh list | sort -Vr)
LATEST=$(scripts/versions.sh latest) || exit 1

{
    echo '<!DOCTYPE html>'
    echo '<html lang="nl">'
    echo '  <head>'
    echo '    <meta charset="UTF-8">'
    echo '    <title>NLCS++ Inhoudelijke Validaties - Documentatie</title>'
    echo '    <link rel="stylesheet" href="doc/NLCSValidatieRegels.css">'
    echo '  </head>'
    echo '  <body>'
    echo '    <h1>NLCS++ Inhoudelijke validaties - Documentatie</h1>'
    echo '    <h2>Versies</h2>'
    echo '    <ul>'
    for VERSION in $VERSIONS; do
        DOC_HTML=$VERSION/doc/NLCSValidatieRegels.html
        if [[ ! -f $DOC_HTML ]]; then
            echo "generate_pages_index.sh: $DOC_HTML does not exist" >&2
            exit 1
        fi
        LABEL=$VERSION
        [[ $VERSION == "$LATEST" ]] && LABEL="$VERSION (nieuwste)"
        echo "      <li><a href=\"$DOC_HTML\">$LABEL</a></li>"
    done
    echo '    </ul>'
    echo '  </body>'
    echo '</html>'
} > "$OUTPUT"
