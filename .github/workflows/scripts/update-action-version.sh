#!/bin/bash
set -euo pipefail

sed_i() {
  local file="$1"
  local sed_expr="$2"

  if sed -i -E "$sed_expr" "$file" 2>/dev/null; then
    :
  else
    sed -i '' -E "$sed_expr" "$file"
  fi
}

update_action_version() {
  echo "start: update_action_version"

  local file="$1"
  local version="$(printf "%s" "$2" | sed "s/'/'\"'\"'/g")"

  if [ -f "$file" ]; then
    if grep -q '^version:' "$file"; then
      sed_i "$file" "s/^version:.*/version: '$version'/"
    elif grep -q '^description:' "$file"; then
      sed_i "$file" "/^description:/a version: '$version'"
    elif grep -q '^name:' "$file"; then
      sed_i "$file" "/^name:/a version: '$version'"
    else
      sed_i "$file" "1i version: '$version'"
    fi
  fi

  echo "end: update_action_version"
}
