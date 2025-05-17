#!/bin/bash
set -euo pipefail

git_add() {
  local first_ignore="$1"
  local second_ignore="$2"

  local first_line second_line target

  local first_ignores=()
  while IFS= read -r first_line; do first_ignores+=("$first_line"); done <<< "$first_ignore"

  local second_ignores=()
  while IFS= read -r second_line; do second_ignores+=("$second_line"); done <<< "$second_ignore"

  git add .

  echo "add-start:"

  for target in "${first_ignores[@]}"; do
    if ! printf "%s\n" "${second_ignores[@]}" | grep -qxF "$target"; then
      echo "ditambahkan-paksa: " "$target"
      git add --force -- "$target"
    fi
  done

  echo "add-end:"
}
