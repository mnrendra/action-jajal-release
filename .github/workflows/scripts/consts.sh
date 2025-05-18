#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

ACTION_FILE="action.yml"
BRANCH="main"
GHA_IGNORE_FILE=".ghaignore"
GIT_IGNORE_FILE=".gitignore"
