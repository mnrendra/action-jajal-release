#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

remove() {
  echo "----------start-remove----------"
  local target="$1"

  if [[ "$target" == */ ]]; then
    git rm --cached --ignore-unmatch -r -- "$target" 2>/dev/null || true
  else
    git rm --cached --ignore-unmatch -- "$target" 2>/dev/null || true
  fi
  echo "----------end-remove------------"
}
