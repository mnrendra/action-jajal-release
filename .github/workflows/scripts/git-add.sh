#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"

git_add() {
  echo "start: git_add"

  local first_ignore="$1"
  local second_ignore="$2"

  local first_line second_line target

  local first_ignores=()
  while IFS= read -r first_line; do first_ignores+=("$first_line"); done < <("$first_ignore")

  local second_ignores=()
  while IFS= read -r second_line; do second_ignores+=("$second_line"); done < <("$second_ignore")

  git add .

  for target in "${first_ignores[@]}"; do
    if ! printf "%s\n" "${second_ignores[@]}" | grep -qxF "$target"; then
      git add --force -- "$target"
    fi
  done

  echo "end: git_add"
}
