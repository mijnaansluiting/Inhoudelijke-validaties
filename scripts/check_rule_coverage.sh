#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
RULES="doc/$VERSION/NLCSValidatieRegels.xml"
PHASES="validation_schemas/$VERSION/main.sch"

grep -o 'nummer="R\.[0-9]\+"' "$RULES" | grep -o 'R\.[0-9]\+' | sort -u > rules.txt
grep -o 'id="R\.[0-9]\+"' "$PHASES" | grep -o 'R\.[0-9]\+' | sort -u > phases.txt

MISSING=$(comm -23 rules.txt phases.txt)
EXTRA=$(comm -13 rules.txt phases.txt)
rm rules.txt phases.txt

report_annotation() {
  local TYPE="$1"
  local FILE="$2"
  local SEARCH="$3"
  local MSG="$4"
  local LINE
  LINE=$(grep -n "$SEARCH" "$FILE" | head -n1 | cut -d: -f1)
  if [ -n "$LINE" ]; then
    echo "::$TYPE file=$FILE,line=$LINE::$MSG"
  else
    echo "::$TYPE file=$FILE::$MSG"
  fi
}

if [ -z "$MISSING" ] && [ -z "$EXTRA" ]; then
  echo "All rules are implemented."
  exit 0
fi

if [ -n "$MISSING" ]; then
  while read -r RULE; do
    [ -z "$RULE" ] && continue
    report_annotation "warning" "$RULES" "nummer=\"$RULE\"" "Rule $RULE is missing in $PHASES"
  done <<< "$MISSING"
fi

if [ -n "$EXTRA" ]; then
  while read -r RULE; do
    [ -z "$RULE" ] && continue
    report_annotation "error" "$PHASES" "id=\"$RULE\"" "Phase $RULE is extra (not in $RULES)"
  done <<< "$EXTRA"
fi

exit 1
