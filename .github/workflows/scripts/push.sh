#!/bin/bash
set -euo pipefail

push() {
  local branch="$1"
  local message="$2"
  local tag="${3:-""}"

  git commit -S --allow-empty -m "$message"
  git push origin "$branch"

  if [ -n "$tag" ]; then
    git tag -d "$tag" 2>/dev/null || true
    git push origin -d tag "$tag" 2>/dev/null || true

    git tag -s "$tag" -m "$message"
    git push origin "$tag"
  fi
}
