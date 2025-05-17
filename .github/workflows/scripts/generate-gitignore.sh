#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"

generate_gitignore() {
  local parsed_gha_ignore="$1"

  local line target

  local gha_ignores=()
  while IFS= read -r line; do gha_ignores+=("$line"); done <<< "$parsed_gha_ignore"

  for target in "${gha_ignores[@]}"; do
    echo "$target" >> "$GIT_IGNORE_FILE"

    if [[ "$target" == */ ]]; then
      git rm --cached --ignore-unmatch -r -- "$target" || true
    else
      git rm --cached --ignore-unmatch -- "$target" || true
    fi
  done
}
