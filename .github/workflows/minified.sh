#!/bin/bash
set -euo pipefail
set -euo pipefail
ACTION_FILE="action.yml"
BRANCH="main"
GHA_IGNORE_FILE=".ghaignore"
GIT_IGNORE_FILE=".gitignore"
set -euo pipefail
trim() {
  local value="$1"
  local trimmed
  trimmed="${value#"${value%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  echo "$trimmed"
}
parse_ignore() {
  local ignore_file="$1"
  local line trimmed
  local result=()
  while IFS= read -r line; do
    trimmed="$(trim "$line")"
    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue
    if ! printf "%s\n" "${result[@]}" | grep -qxF "$trimmed"; then
      result+=("$trimmed")
    fi
  done < "$ignore_file"
  printf '%s\n' "${result[@]}"
}
set -euo pipefail
backup_gitignore() {
  local file="$GIT_IGNORE_FILE"
  if [ -f "$file" ]; then
    mv "$file" "$file.backup"
  fi
}
set -euo pipefail
generate_gitignore() {
  local parsed_gha_ignore="$1"
  local line target
  local gha_ignores=()
  while IFS= read -r line; do gha_ignores+=("$line"); done <<< "$parsed_gha_ignore"
  for target in "${gha_ignores[@]}"; do
    echo "$target" >> "$GIT_IGNORE_FILE"
    if [[ "$target" == */ ]]; then
      git rm --cached --ignore-unmatch -r -- "$target" 2>/dev/null || true
    else
      git rm --cached --ignore-unmatch -- "$target" 2>/dev/null || true
    fi
  done
}
set -euo pipefail
sed_i() {
  local file="$1"
  local sed_expr="$2"
  if sed -i -E "$sed_expr" "$file" 2>/dev/null; then
    :
  else
    sed -i '' -E "$sed_expr" "$file"
  fi
}
update_action_version() {
  local file="$1"
  local version="$(printf "%s" "$2" | sed "s/'/'\"'\"'/g")"
  if [ -f "$file" ]; then
    if grep -q '^version:' "$file"; then
      sed_i "$file" "s/^version:.*/version: '$version'/"
    elif grep -q '^description:' "$file"; then
      sed_i "$file" "/^description:/a version: '$version'"
    elif grep -q '^name:' "$file"; then
      sed_i "$file" "/^name:/a version: '$version'"
    else
      sed_i "$file" "1i version: '$version'"
    fi
  fi
}
set -euo pipefail
git_add() {
  local first_ignore="$1"
  local second_ignore="$2"
  local first_line second_line target
  local first_ignores=()
  while IFS= read -r first_line; do first_ignores+=("$first_line"); done <<< "$first_ignore"
  local second_ignores=()
  while IFS= read -r second_line; do second_ignores+=("$second_line"); done <<< "$second_ignore"
  git add .
  for target in "${first_ignores[@]}"; do
    if ! printf "%s\n" "${second_ignores[@]}" | grep -qxF "$target"; then
      if [ -e "$target" ]; then
        git add --force -- "$target" 2>/dev/null || true
      fi
    fi
  done
}
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
set -euo pipefail
restore_gitignore() {
  local file="$GIT_IGNORE_FILE"
  if [ -f "$file" ]; then
    rm -f "$file"
  fi
  if [ -f "$file.backup" ]; then
    mv "$file.backup" "$file"
  fi
}
set -euo pipefail
unstage_ghaignore() {
  local parsed_git_ignore="$1"
  local parsed_gha_ignore="$2"
  local git_line gha_line target
  local git_ignores=()
  while IFS= read -r git_line; do git_ignores+=("$git_line"); done <<< "$parsed_git_ignore"
  local gha_ignores=()
  while IFS= read -r gha_line; do gha_ignores+=("$gha_line"); done <<< "$parsed_gha_ignore"
  for target in "${git_ignores[@]}"; do
    if ! printf "%s\n" "${gha_ignores[@]}" | grep -qxF "$target"; then
      if [[ "$target" == */ ]]; then
        git rm --cached --ignore-unmatch -r -- "$target" 2>/dev/null || true
      else
        git rm --cached --ignore-unmatch -- "$target" 2>/dev/null || true
      fi
    fi
  done
}
main() {
  echo "pakai minified"
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
    git_add "$parsed_git_ignore" "$parsed_gha_ignore"
    push "$branch" "$release_message" "$tag"
    restore_gitignore
    unstage_ghaignore "$parsed_git_ignore" "$parsed_gha_ignore"
    git_add "$parsed_gha_ignore" "$parsed_git_ignore"
    push "$branch" "$latest_message"
  fi
}
main "$1" "${2:-""}" "${3:-""}" "${4:-""}" "${5:-""}" "${6:-""}" "${7:-""}"
