#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"
source "$(dirname "$0")/recursive.sh"

unstage_ghaignore() {
  echo "start: unstage_ghaignore"

  local parsed_git_ignore="$1"
  local parsed_gha_ignore="$2"

  local git_line gha_line target

  local git_ignores=()
  while IFS= read -r git_line; do git_ignores+=("$git_line"); done <<< "$parsed_git_ignore"

  local gha_ignores=()
  while IFS= read -r gha_line; do gha_ignores+=("$gha_line"); done <<< "$parsed_gha_ignore"

  for target in "${git_ignores[@]}"; do
    if ! printf "%s\n" "${gha_ignores[@]}" | grep -qxF "$target"; then
      recursive_flag="$(recursive "$target")"
      git rm --cached --ignore-unmatch "$recursive_flag" -- "$target" || true
    fi
  done

  echo "end: unstage_ghaignore"
}
