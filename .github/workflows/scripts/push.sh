#!/bin/bash
set -euo pipefail

push() {
  local branch="$1"
  local message="$2"
  local tag="${3:-""}"

  git config --list

  git commit -S --allow-empty -m "$message"
  git push origin "$branch"

  if [ -n "$tag" ]; then
    git tag -d "$tag" || true
    git push origin -d tag "$tag" || true

    git tag -s "$tag" -m "$message"
    git push origin "$tag"
  fi
}
