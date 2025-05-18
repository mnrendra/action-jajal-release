#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

isvalid() {
  local path="$1"

  if [[ "$path" =~ ^([^[:cntrl:]]|/)+$ ]] && [[ "$path" != *".."* ]]; then
    return 0
  else
    return 1
  fi
}
