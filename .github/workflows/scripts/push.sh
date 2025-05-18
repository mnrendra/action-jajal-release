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
  local warning="not sending a push certificate since the receiving end does not support --signed push"

  if hasgpgkey; then
    git commit -S --allow-empty -m -- "$message"
  else
    git commit --allow-empty -m -- "$message"
  fi

  git push origin "$branch" 2> >(grep -v -- "$warning" >&2)

  if [ -n "$tag" ]; then
    git tag -d -- "$tag" 2>/dev/null || true

    git push origin -d tag -- "$tag" 2>/dev/null

    if hasgpgkey; then
      git tag -s "$tag" -m -- "$message"
    else
      git tag "$tag" -m -- "$message"
    fi

    git push origin -- "$tag" 2> >(grep -v -- "$warning" >&2)
  fi
}
