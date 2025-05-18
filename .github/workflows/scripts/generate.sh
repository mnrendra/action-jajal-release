#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/consts.sh"
source "$(dirname "$0")/remove.sh"

generate() {
  local parsed_gha_ignore="$1"

  local line target

  local gha_ignores=()
  while IFS= read -r line || [[ -n "$line" ]]; do gha_ignores+=("$line"); done <<< "$parsed_gha_ignore"

  for target in "${gha_ignores[@]}"; do
    echo "$target" >> "$GIT_IGNORE_FILE"
  done
}
