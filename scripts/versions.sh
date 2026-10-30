#!/bin/bash

# Query the version registry (configuration/versions.xml).
#
#   versions.sh list [--released]   all version ids, oldest first
#   versions.sh latest [xsd]        newest released version (for an XSD version)
#   versions.sh resolve <version>   full id for vYEAR.RELEASE.FIX or vYEAR.RELEASE (newest fix)
#   versions.sh xsd <version>       XSD version a version targets
#   versions.sh rules <version>     "R.x <version>" per phase: the folder its pattern is included from
#   versions.sh base <version>      version it inherits from (empty for the base)
#   versions.sh xsds                distinct XSD versions
#   versions.sh matrix              JSON array of all version ids (CI matrix)

REGISTRY="${VERSIONS_REGISTRY:-$(dirname "$0")/../configuration/versions.xml}"

# Prints one "id nlcspp base released" line per <version/>, sorted oldest first
entries() {
    grep '<version ' "$REGISTRY" | while read -r LINE; do
        ID=$(sed -n 's/.* id="\([^"]*\)".*/\1/p' <<< "$LINE")
        NLCSPP=$(sed -n 's/.* nlcspp="\([^"]*\)".*/\1/p' <<< "$LINE")
        BASE=$(sed -n 's/.* base="\([^"]*\)".*/\1/p' <<< "$LINE")
        RELEASED=$(sed -n 's/.* released="\([^"]*\)".*/\1/p' <<< "$LINE")
        echo "$ID $NLCSPP ${BASE:--} $RELEASED"
    done | sort -V
}

field() {
    local VERSION=$1
    local COLUMN=$2
    entries | awk -v id="$VERSION" -v col="$COLUMN" '$1 == id { print $col; found = 1 } END { exit !found }'
}

fail() {
    echo "versions.sh: $1" >&2
    exit 1
}

case "$1" in
    list)
        if [[ "$2" == "--released" ]]; then
            entries | awk '$4 == "true" { print $1 }'
        else
            entries | awk '{ print $1 }'
        fi
        ;;
    latest)
        LATEST=$(entries | awk -v xsd="$2" '$4 == "true" && (xsd == "" || $2 == xsd) { print $1 }' | tail -n1)
        [[ -n "$LATEST" ]] || fail "no released version${2:+ for XSD $2}"
        echo "$LATEST"
        ;;
    resolve)
        [[ -n "$2" ]] || fail "a version is required, e.g. v2026.1.0 (see: scripts/versions.sh list)"
        if [[ "$2" =~ ^v[0-9]{4}\.[0-9]+\.[0-9]+$ ]]; then
            RESOLVED=$(entries | awk -v v="$2" '$1 == v { print $1 }')
        elif [[ "$2" =~ ^v[0-9]{4}\.[0-9]+$ ]]; then
            RESOLVED=$(entries | awk -v v="$2" 'index($1, v ".") == 1 { print $1 }' | tail -n1)
        fi
        [[ -n "$RESOLVED" ]] || fail "unknown version $2"
        echo "$RESOLVED"
        ;;
    xsd)
        field "$2" 2 || fail "unknown version $2"
        ;;
    rules)
        VERSION=$("$0" resolve "$2") || exit 1
        SCHEMA_NAME=validation_schemas/$VERSION/main.sch
        SCHEMA="$(dirname "$0")/../$SCHEMA_NAME"
        [[ -f "$SCHEMA" ]] || fail "$SCHEMA_NAME does not exist"

        # Pattern include paths, e.g. patterns/R.7.sch or ../v2026.1.0/patterns/R.4_A.sch
        PATTERN_INCLUDES=$(sed -n 's#.*<include href="\(\(\.\./v[^/]*/\)\{0,1\}patterns/R\.[0-9][^"]*\)".*#\1#p' "$SCHEMA")

        ALL_RULES_FOUND=true
        for RULE in $(grep -o '<phase id="R\.[0-9]\+"' "$SCHEMA" | grep -o 'R\.[0-9]\+'); do
            # R.4 matches R.4.sch and R.4_A.sch, not R.40.sch
            INCLUDE=$(grep -m1 -E "(^|/)patterns/${RULE//./\\.}(_[^/]*)?\.sch$" <<< "$PATTERN_INCLUDES")
            if [[ -z "$INCLUDE" ]]; then
                echo "versions.sh: $RULE is a phase in $SCHEMA_NAME, but has no pattern include" >&2
                ALL_RULES_FOUND=false
            elif [[ "$INCLUDE" =~ ^\.\./(v[^/]+)/ ]]; then
                echo "$RULE ${BASH_REMATCH[1]}"
            else
                echo "$RULE $VERSION"
            fi
        done
        [[ "$ALL_RULES_FOUND" == true ]] || exit 1
        ;;
    base)
        BASE=$(field "$2" 3) || fail "unknown version $2"
        [[ "$BASE" == "-" ]] || echo "$BASE"
        ;;
    xsds)
        entries | awk '{ print $2 }' | sort -uV
        ;;
    matrix)
        entries | awk '{ printf "%s\"%s\"", (NR > 1 ? "," : "["), $1 } END { print "]" }'
        ;;
    *)
        sed -n '3,12s/^# \?//p' "$0"
        exit 1
        ;;
esac
