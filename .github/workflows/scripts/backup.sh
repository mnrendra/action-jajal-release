#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/consts.sh"

backup() {
  echo "----------start-backup----------"
  local file="$GIT_IGNORE_FILE"

  if [ -f "$file" ]; then
    cp -- "$file" "$file.backup"
    rm -f -- "$file"
  fi
  echo "----------end-backup------------"
}
