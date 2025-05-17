#!/bin/bash
set -euo pipefail

# . $HOME/.profile

source "$(dirname "$0")/consts.sh"
source "$(dirname "$0")/parse-ignore.sh"
source "$(dirname "$0")/backup-gitignore.sh"
source "$(dirname "$0")/generate-gitignore.sh"
source "$(dirname "$0")/update-action-version.sh"
source "$(dirname "$0")/git-add.sh"
source "$(dirname "$0")/push.sh"
source "$(dirname "$0")/restore-gitignore.sh"
source "$(dirname "$0")/unstage-ghaignore.sh"

main() {
  echo "start: main"

  local version="$1"
  local notes="${2:-""}"
  local branch="${3:-"$BRANCH"}"
  local action_file="${4:-"$ACTION_FILE"}"
  local tag="${5:-"v$version"}"
  local release_message="${6:-"release: "$tag""$'\n\n'"$notes"}"
  local latest_message="${7:-"latest: "$tag""}"
  local parsed_gha_ignore
  local parsed_git_ignore

  if [ -n "${version:-}" ] && [ -n "${branch:-}" ]; then
    parsed_gha_ignore="$(parse_ignore "$GHA_IGNORE_FILE")"
    parsed_git_ignore="$(parse_ignore "$GIT_IGNORE_FILE")"

    backup_gitignore

    generate_gitignore "$parsed_gha_ignore"

    update_action_version "$action_file" "$version"

    git_add "$GIT_IGNORE_FILE" "$GHA_IGNORE_FILE"

    push "$branch" "$release_message" "$tag"

    restore_gitignore

    unstage_ghaignore "$parsed_git_ignore" "$parsed_gha_ignore"

    git_add "$GHA_IGNORE_FILE" "$GIT_IGNORE_FILE"

    push "$branch" "$latest_message"
  fi

  echo "end: main"
}

main
