#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

input="$1"
output="$2"

if [[ -z "$input" ]]; then
  echo "Usage: $0 <input.sh> [output.sh]"
  exit 1
fi

awk '
  # Remove comments, preserve shebang
  NR == 1 && /^#!/ { print; next }
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*$/ { next }
  { gsub(/[[:space:]]+$/, ""); print }
' "$input" > "$output"

chmod +x "$output"
echo "✅ Minified: $output"
