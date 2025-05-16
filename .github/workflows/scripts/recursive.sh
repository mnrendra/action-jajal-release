#!/bin/bash
set -euo pipefail

recursive() {
  echo "start: recursive"

  local target="$1"

  if [[ "$target" == */ ]]; then
    echo "-r"
  else
    echo ""
  fi

  echo "end: recursive"
}
