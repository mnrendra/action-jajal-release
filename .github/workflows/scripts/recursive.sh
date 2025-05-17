#!/bin/bash
set -euo pipefail

recursive() {
  local target="$1"

  if [[ "$target" == */ ]]; then
    echo "-r"
  else
    echo ""
  fi
}
