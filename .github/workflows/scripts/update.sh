#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sedi() {
  local file="$1"
  local sed_expr="$2"

  if sed -i -E "$sed_expr" "$file" 2>/dev/null; then
    :
  else
    sed -i '' -E "$sed_expr" "$file"
  fi
}

escape() {
  local str="$1"
  str="${str//\'/''}"
  echo "$str"
}

update() {
  local file="$1"
  local version="$(escape "$(printf "%s" "$2" | sed "s/'/'\"'\"'/g")")"

  if [ -f "$file" ]; then
    if grep -q '^version:' "$file"; then
      sedi "$file" "s/^version:.*/version: '$version'/"
    elif grep -q '^name:' "$file"; then
      sedi "$file" "/^name:/a version: '$version'"
    else
      sedi "$file" "1i version: '$version'"
    fi
  fi
}
