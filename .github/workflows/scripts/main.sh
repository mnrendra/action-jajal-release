#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/consts.sh"
source "$(dirname "$0")/parse.sh"
source "$(dirname "$0")/backup.sh"
source "$(dirname "$0")/generate.sh"
source "$(dirname "$0")/update.sh"
source "$(dirname "$0")/sync.sh"
source "$(dirname "$0")/push.sh"
source "$(dirname "$0")/restore.sh"

main() {
  local version="$1"
  local notes="${2:-""}"
  local branch="${3:-"$BRANCH"}"
  local action_file="${4:-"$ACTION_FILE"}"
  local tag="${5:-"v$version"}"
  local release_message="${6:-"release: $tag"$'\n\n'"$notes"}"
  local latest_message="${7:-"latest: $tag"}"
  local parsed_gha_ignore
  local parsed_git_ignore

  if [ -n "${version:-}" ] && [ -n "${branch:-}" ]; then
    parsed_gha_ignore="$(parse "$GHA_IGNORE_FILE")"
    parsed_git_ignore="$(parse "$GIT_IGNORE_FILE")"

    echo "[INFO] Backing up $GIT_IGNORE_FILE"
    backup
    echo "[SUCCESS] ✅ $GIT_IGNORE_FILE was successfully backed up"

    echo "[INFO] Generating new $GIT_IGNORE_FILE from $GHA_IGNORE_FILE"
    generate "$parsed_gha_ignore"
    echo "[SUCCESS] ✅ New $GIT_IGNORE_FILE was successfully generated"

    echo "[INFO] Updating version in $action_file"
    update "$action_file" "$version"
    echo "[SUCCESS] ✅ $action_file was successfully updated"

    echo "[INFO] Syncing ignore patterns from $GIT_IGNORE_FILE to $GHA_IGNORE_FILE"
    sync "$parsed_git_ignore" "$parsed_gha_ignore"
    echo "[SUCCESS] ✅ Ignore patterns were successfully synced"

    echo "[INFO] Releasing tag $tag"
    push "$branch" "$release_message" "$tag"
    echo "[SUCCESS] ✅ Tag $tag was successfully released"

    echo "[INFO] Restoring $GIT_IGNORE_FILE"
    restore
    echo "[SUCCESS] ✅ $GIT_IGNORE_FILE was successfully restored"

    echo "[INFO] Syncing ignore patterns from $GHA_IGNORE_FILE to $GIT_IGNORE_FILE"
    sync "$parsed_gha_ignore" "$parsed_git_ignore"
    echo "[SUCCESS] ✅ Ignore patterns were successfully synced"

    echo "[INFO] Pushing latest commit $tag on branch '$branch'"
    push "$branch" "$latest_message"
    echo "[SUCCESS] ✅ Branch '$branch' was successfully updated with the latest commit $tag"
  fi
}

main "$@"
