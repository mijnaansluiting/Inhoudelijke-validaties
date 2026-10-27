#!/bin/bash

# Query the version registry (configuration/versions.xml).
#
#   versions.sh list [--released]   all version ids, oldest first
#   versions.sh latest [xsd]        newest released version (for an XSD version)
#   versions.sh resolve <version>   full id for vYEAR.RELEASE.FIX or vYEAR.RELEASE (newest fix)
#   versions.sh xsd <version>       XSD version a version targets
#   versions.sh base <version>      version it inherits from (empty for the base)
#   versions.sh xsds                distinct XSD versions
#   versions.sh matrix              JSON array of all version ids (CI matrix)

registry="${VERSIONS_REGISTRY:-$(dirname "$0")/../configuration/versions.xml}"

# Prints one "id xsd base released" line per <version/>, sorted oldest first
entries() {
    grep '<version ' "$registry" | while read -r line; do
        id=$(sed -n 's/.* id="\([^"]*\)".*/\1/p' <<< "$line")
        xsd=$(sed -n 's/.* xsd="\([^"]*\)".*/\1/p' <<< "$line")
        base=$(sed -n 's/.* base="\([^"]*\)".*/\1/p' <<< "$line")
        released=$(sed -n 's/.* released="\([^"]*\)".*/\1/p' <<< "$line")
        echo "$id $xsd ${base:--} $released"
    done | sort -V
}

field() {
    local version=$1
    local column=$2
    entries | awk -v id="$version" -v col="$column" '$1 == id { print $col; found = 1 } END { exit !found }'
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
        latest=$(entries | awk -v xsd="$2" '$4 == "true" && (xsd == "" || $2 == xsd) { print $1 }' | tail -n1)
        [[ -n "$latest" ]] || fail "no released version${2:+ for XSD $2}"
        echo "$latest"
        ;;
    resolve)
        if [[ "$2" =~ ^v[0-9]{4}\.[0-9]+\.[0-9]+$ ]]; then
            resolved=$(entries | awk -v v="$2" '$1 == v { print $1 }')
        elif [[ "$2" =~ ^v[0-9]{4}\.[0-9]+$ ]]; then
            resolved=$(entries | awk -v v="$2" 'index($1, v ".") == 1 { print $1 }' | tail -n1)
        fi
        [[ -n "$resolved" ]] || fail "unknown version $2"
        echo "$resolved"
        ;;
    xsd)
        field "$2" 2 || fail "unknown version $2"
        ;;
    base)
        base=$(field "$2" 3) || fail "unknown version $2"
        [[ "$base" == "-" ]] || echo "$base"
        ;;
    xsds)
        entries | awk '{ print $2 }' | sort -uV
        ;;
    matrix)
        entries | awk '{ printf "%s\"%s\"", (NR > 1 ? "," : "["), $1 } END { print "]" }'
        ;;
    *)
        sed -n '3,11s/^# \?//p' "$0"
        exit 1
        ;;
esac
