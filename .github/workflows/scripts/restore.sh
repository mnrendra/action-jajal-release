#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/consts.sh"

restore() {
  echo "----------start-restore----------"
  local file="$GIT_IGNORE_FILE"
  local backup_file="$file.backup"

  if [ -f "$file" ]; then
    rm -f -- "$file"
  fi

  if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
    cp -- "$backup_file" "$file"
    rm -f -- "$backup_file"
  fi
  echo "----------end-restore------------"
}
