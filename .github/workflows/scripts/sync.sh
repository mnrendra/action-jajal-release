#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/isvalid.sh"
source "$(dirname "$0")/remove.sh"

sync() {
  local src_ignore="$1"
  local dst_ignore="$2"
  local src_line dst_line
  local src_list=()
  local dst_list=()

  while IFS= read -r src_line || [[ -n "$src_line" ]]; do src_list+=("$src_line"); done <<< "$src_ignore"
  while IFS= read -r dst_line || [[ -n "$dst_line" ]]; do dst_list+=("$dst_line"); done <<< "$dst_ignore"

  git add .

  for target in "${dst_list[@]}"; do
    if ! printf "%s\n" "${src_list[@]}" | grep -qxF -- "$target"; then
      if isvalid "$target"; then
        remove "$target"
      fi
    fi
  done

  for target in "${src_list[@]}"; do
    if ! printf "%s\n" "${dst_list[@]}" | grep -qxF -- "$target"; then
      if [ -e "$target" ] && isvalid "$target"; then
        git add --force -- "$target" 2>/dev/null || true
      fi
    fi
  done
}
