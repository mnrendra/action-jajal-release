#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/consts.sh"

backup_gitignore() {
  echo "start: backup_gitignore"

  local file="$GIT_IGNORE_FILE"

  if [ -f "$file" ]; then
    mv "$file" "$file.backup"
  fi

  echo "end: backup_gitignore"
}
