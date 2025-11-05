#!/bin/bash

RULES="doc/NLCSValidatieRegels.xml"
PHASES="validation_schemas/base/v12.sch"

grep -o 'nummer="R\.[0-9]\+"' "$RULES" | grep -o 'R\.[0-9]\+' | sort -u > rules.txt
grep -o 'id="R\.[0-9]\+"' "$PHASES" | grep -o 'R\.[0-9]\+' | sort -u > phases.txt

missing=$(comm -23 rules.txt phases.txt)
extra=$(comm -13 rules.txt phases.txt)
rm rules.txt phases.txt

report_annotation() {
  local type="$1"
  local file="$2"
  local search="$3"
  local msg="$4"
  local line
  line=$(grep -n "$search" "$file" | head -n1 | cut -d: -f1)
  if [ -n "$line" ]; then
    echo "::$type file=$file,line=$line::$msg"
  else
    echo "::$type file=$file::$msg"
  fi
}

if [ -z "$missing" ] && [ -z "$extra" ]; then
  echo "All rules are implemented."
  exit 0
fi

if [ -n "$missing" ]; then
  while read -r rule; do
    [ -z "$rule" ] && continue
    report_annotation "warning" "$RULES" "nummer=\"$rule\"" "Rule $rule is missing in $PHASES"
  done <<< "$missing"
fi

if [ -n "$extra" ]; then
  while read -r rule; do
    [ -z "$rule" ] && continue
    report_annotation "error" "$PHASES" "id=\"$rule\"" "Phase $rule is extra (not in $RULES)"
  done <<< "$extra"
fi

exit 1
