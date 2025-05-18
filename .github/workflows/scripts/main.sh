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

    backup

    generate "$parsed_gha_ignore"

    update "$action_file" "$version"

    sync "$parsed_git_ignore" "$parsed_gha_ignore"

    push "$branch" "$release_message" "$tag"

    restore

    sync "$parsed_gha_ignore" "$parsed_git_ignore"

    push "$branch" "$latest_message"
  fi
}

main "$@"
