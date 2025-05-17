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

    echo "diabaikan-rilis:" "$target"

    if [[ "$target" == */ ]]; then
      echo "cabut-rilis: -r" "$target"
      git rm --cached --ignore-unmatch -r -- "$target" || true
    else
      echo "cabut-rilis:" "$target"
      git rm --cached --ignore-unmatch -- "$target" || true
    fi
  done
}
