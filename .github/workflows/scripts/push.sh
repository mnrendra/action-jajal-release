#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

hasgpgkey() {
  if git config user.signingkey >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

push() {
  local branch="$1"
  local message="$2"
  local tag="${3:-""}"

  if hasgpgkey; then
    git commit -S --allow-empty -m "$message"
  else
    git commit --allow-empty -m "$message"
  fi

  git push origin "$branch"

  if [ -n "$tag" ]; then
    git tag -d "$tag" 2>/dev/null || true

    git push origin -d tag "$tag"

    if hasgpgkey; then
      git tag -s "$tag" -m "$message"
    else
      git tag "$tag" -m "$message"
    fi

    git push origin "$tag"
  fi
}
