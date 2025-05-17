#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"
source "$(dirname "$0")/recursive.sh"

generate_gitignore() {
  echo "start: generate_gitignore"

  local parsed_gha_ignore="$1"

  local line target recursive_flag

  echo "susu:" "$parsed_gha_ignore"

  local gha_ignores=()
  while IFS= read -r line; do gha_ignores+=("$line"); done < <("$parsed_gha_ignore")

  for target in "${gha_ignores[@]}"; do
    echo "$target" >> "$GIT_IGNORE_FILE"

    recursive_flag="$(recursive "$target")"
    git rm --cached --ignore-unmatch "$recursive_flag" -- "$target" || true
  done

  ls -laihs
  cat .gitignore

  echo "end: generate_gitignore"
}
