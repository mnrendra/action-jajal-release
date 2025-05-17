#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"

restore_gitignore() {
  local file="$GIT_IGNORE_FILE"

  if [ -f "$file" ]; then
    rm -f "$file"
  fi

  if [ -f "$file.backup" ]; then
    mv "$file.backup" "$file"
  fi
}
