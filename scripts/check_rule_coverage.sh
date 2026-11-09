#!/bin/bash

VERSION=$(scripts/versions.sh resolve "$1") || exit 1
RULES="$VERSION/doc/NLCSValidatieRegels.xml"
PHASES="$VERSION/rules/main.sch"

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

FAILED=false

if [ -n "$MISSING" ]; then
  FAILED=true
  while read -r RULE; do
    [ -z "$RULE" ] && continue
    report_annotation "warning" "$RULES" "nummer=\"$RULE\"" "Rule $RULE is missing in $PHASES"
  done <<< "$MISSING"
fi

if [ -n "$EXTRA" ]; then
  FAILED=true
  while read -r RULE; do
    [ -z "$RULE" ] && continue
    report_annotation "error" "$PHASES" "id=\"$RULE\"" "Phase $RULE is extra (not in $RULES)"
  done <<< "$EXTRA"
fi

# Every rule's pattern must be included from the version folder its <laatstGewijzigd> names,
# e.g. laatstGewijzigd v12 -> ../../v12/rules/patterns/R.x.sch, v12.1 in v12.1 -> patterns/R.x.sch.

# "R.x <version folder the pattern is included from>" per phase in main.sch
if ! INCLUDED_FROM=$(scripts/versions.sh rules "$VERSION"); then
  echo "::error file=$PHASES::Could not determine the pattern include of every phase in $PHASES"
  exit 1
fi

# "R.x <laatstGewijzigd>" per rule in the documentation XML
LAST_UPDATED=$(awk '
  match($0, /nummer="R\.[0-9]+"/) { rule = substr($0, RSTART + 8, RLENGTH - 9) }
  match($0, /<laatstGewijzigd>[^<]*<\/laatstGewijzigd>/) { print rule, substr($0, RSTART + 17, RLENGTH - 35) }
' "$RULES")

while read -r RULE FOLDER; do
  [ -z "$RULE" ] && continue
  # Rules missing from the documentation XML are already reported above
  grep -qxF "$RULE" <<< "$EXTRA" && continue
  UPDATED=$(awk -v rule="$RULE" '$1 == rule { print $2; exit }' <<< "$LAST_UPDATED")
  if [ -z "$UPDATED" ]; then
    FAILED=true
    report_annotation "error" "$RULES" "nummer=\"$RULE\"" "Rule $RULE has no laatstGewijzigd in $RULES"
  elif [ "$UPDATED" != "$FOLDER" ]; then
    FAILED=true
    report_annotation "error" "$PHASES" "patterns/${RULE}[._]" "Rule $RULE was last updated in $UPDATED (laatstGewijzigd in $RULES), but its pattern is included from $FOLDER"
  fi
done <<< "$INCLUDED_FROM"

if [ "$FAILED" = true ]; then
  exit 1
fi

echo "All rules are implemented and included from the version they were last updated in."
exit 0
