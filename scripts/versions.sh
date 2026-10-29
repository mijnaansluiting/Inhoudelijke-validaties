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

registry="${VERSIONS_REGISTRY:-$(dirname "$0")/../configuration/versions.xml}"

# Prints one "id nlcspp base released" line per <version/>, sorted oldest first
entries() {
    grep '<version ' "$registry" | while read -r line; do
        id=$(sed -n 's/.* id="\([^"]*\)".*/\1/p' <<< "$line")
        nlcspp=$(sed -n 's/.* nlcspp="\([^"]*\)".*/\1/p' <<< "$line")
        base=$(sed -n 's/.* base="\([^"]*\)".*/\1/p' <<< "$line")
        released=$(sed -n 's/.* released="\([^"]*\)".*/\1/p' <<< "$line")
        echo "$id $nlcspp ${base:--} $released"
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
    rules)
        version=$("$0" resolve "$2") || exit 1
        schema_name=validation_schemas/$version/main.sch
        schema="$(dirname "$0")/../$schema_name"
        [[ -f "$schema" ]] || fail "$schema_name does not exist"

        # Pattern include paths, e.g. patterns/R.7.sch or ../v2026.1.0/patterns/R.4_A.sch
        pattern_includes=$(sed -n 's#.*<include href="\(\(\.\./v[^/]*/\)\{0,1\}patterns/R\.[0-9][^"]*\)".*#\1#p' "$schema")

        all_rules_found=true
        for rule in $(grep -o '<phase id="R\.[0-9]\+"' "$schema" | grep -o 'R\.[0-9]\+'); do
            # R.4 matches R.4.sch and R.4_A.sch, not R.40.sch
            include=$(grep -m1 -E "(^|/)patterns/${rule//./\\.}(_[^/]*)?\.sch$" <<< "$pattern_includes")
            if [[ -z "$include" ]]; then
                echo "versions.sh: $rule is a phase in $schema_name, but has no pattern include" >&2
                all_rules_found=false
            elif [[ "$include" =~ ^\.\./(v[^/]+)/ ]]; then
                echo "$rule ${BASH_REMATCH[1]}"
            else
                echo "$rule $version"
            fi
        done
        [[ "$all_rules_found" == true ]] || exit 1
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
        sed -n '3,12s/^# \?//p' "$0"
        exit 1
        ;;
esac
