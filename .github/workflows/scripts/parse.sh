#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/isvalid.sh"

trim() {
  local value="$1"
  local trimmed

  trimmed="${value#"${value%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"

  echo "$trimmed"
}

parse() {
  local file="$1"
  local line trimmed
  local result=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="$(trim "$line")"
    trimmed="${trimmed%%#*}"
    trimmed="$(trim "$trimmed")"

    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue

    isvalid "$trimmed" || continue

    if ! printf "%s\n" "${result[@]}" | grep -qxF -- "$trimmed"; then
      result+=("$trimmed")
    fi
  done < "$file"

  printf '%s\n' "${result[@]}"
}
