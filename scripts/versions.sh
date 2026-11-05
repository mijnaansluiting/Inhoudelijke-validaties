#!/bin/bash

# Query the version registry (configuration/versions.xml). A version is an NLCS++ version: v12, v12.1, ...
#
#   versions.sh list                all version ids, oldest first
#   versions.sh latest              newest version
#   versions.sh resolve <version>   the id itself if it is registered (e.g. v12.1), fails otherwise
#   versions.sh xsd <version>       XSD version a version targets: its id without the v (v12.1 -> 12.1)
#   versions.sh rules <version>     "R.x <version>" per phase: the folder its pattern is included from
#   versions.sh xsds                distinct XSD versions
#   versions.sh matrix              JSON array of all version ids (CI matrix)

REGISTRY="${VERSIONS_REGISTRY:-$(dirname "$0")/../configuration/versions.xml}"

# Prints the id of every <version/>, sorted oldest first
entries() {
    sed -n 's/.*<version [^>]*id="\([^"]*\)".*/\1/p' "$REGISTRY" | sort -V
}

fail() {
    echo "versions.sh: $1" >&2
    exit 1
}

case "$1" in
    list)
        entries
        ;;
    latest)
        LATEST=$(entries | tail -n1)
        [[ -n "$LATEST" ]] || fail "no versions registered"
        echo "$LATEST"
        ;;
    resolve)
        [[ -n "$2" ]] || fail "a version is required, e.g. v12.1 (see: scripts/versions.sh list)"
        entries | grep -qxF -- "$2" || fail "unknown version $2"
        echo "$2"
        ;;
    xsd)
        VERSION=$("$0" resolve "$2") || exit 1
        echo "${VERSION#v}"
        ;;
    rules)
        VERSION=$("$0" resolve "$2") || exit 1
        SCHEMA_NAME=$VERSION/rules/main.sch
        SCHEMA="$(dirname "$0")/../$SCHEMA_NAME"
        [[ -f "$SCHEMA" ]] || fail "$SCHEMA_NAME does not exist"

        # Pattern include paths, e.g. patterns/R.7.sch or ../../v12/rules/patterns/R.4_A.sch
        PATTERN_INCLUDES=$(sed -n 's#.*<include href="\(\(\.\./\.\./v[^/]*/rules/\)\{0,1\}patterns/R\.[0-9][^"]*\)".*#\1#p' "$SCHEMA")

        ALL_RULES_FOUND=true
        for RULE in $(grep -o '<phase id="R\.[0-9]\+"' "$SCHEMA" | grep -o 'R\.[0-9]\+'); do
            # R.4 matches R.4.sch and R.4_A.sch, not R.40.sch
            INCLUDE=$(grep -m1 -E "(^|/)patterns/${RULE//./\\.}(_[^/]*)?\.sch$" <<< "$PATTERN_INCLUDES")
            if [[ -z "$INCLUDE" ]]; then
                echo "versions.sh: $RULE is a phase in $SCHEMA_NAME, but has no pattern include" >&2
                ALL_RULES_FOUND=false
            elif [[ "$INCLUDE" =~ ^\.\./\.\./(v[^/]+)/rules/ ]]; then
                echo "$RULE ${BASH_REMATCH[1]}"
            else
                echo "$RULE $VERSION"
            fi
        done
        [[ "$ALL_RULES_FOUND" == true ]] || exit 1
        ;;
    xsds)
        entries | sed 's/^v//'
        ;;
    matrix)
        entries | awk '{ printf "%s\"%s\"", (NR > 1 ? "," : "["), $1 } END { print "]" }'
        ;;
    *)
        sed -n '3,11s/^# \?//p' "$0"
        exit 1
        ;;
esac
