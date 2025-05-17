#!/bin/bash
set -euo pipefail

push() {
  local branch="$1"
  local message="$2"
  local tag="${3:-""}"

  git config --list
  echo "GIT_AUTHOR_NAME:" "$GIT_AUTHOR_NAME"
  echo "GIT_AUTHOR_EMAIL:" "$GIT_AUTHOR_EMAIL"
  echo "GIT_COMMITTER_NAME:" "$GIT_COMMITTER_NAME"
  echo "GIT_COMMITTER_EMAIL:" "$GIT_COMMITTER_EMAIL"

  git commit -S --allow-empty -m "$message"
  git push origin "$branch"

  if [ -n "$tag" ]; then
    git tag -d "$tag" || true
    git push origin -d tag "$tag" || true

    git tag -s "$tag" -m "$message"
    git push origin "$tag"
  fi
}
