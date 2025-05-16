#!/bin/bash
set -euo pipefail

trim() {
  local value="$1"
  local trimmed

  trimmed="${value#"${value%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"

  echo "$trimmed"
}

parse_ignore() {
  echo "start: parse_ignore"

  local ignore_file="$1"
  local line trimmed
  local result=()

  while IFS= read -r line; do
    trimmed="$(trim "$line")"

    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue

    if ! printf "%s\n" "${result[@]}" | grep -qxF "$trimmed"; then
      result+=("$trimmed")
    fi
  done < "$ignore_file"

  printf '%s\n' "${result[@]}"

  echo "end: parse_ignore"
}
