#!/bin/sh

. ~/.profile

TAG=$1
REPO=$2
HOST="https://github.com/$REPO/archive/refs/tags"

for EXT in zip tar.gz; do
  FILE="$TAG.$EXT"
  curl -L -o "$FILE" "$HOST/$FILE"
  sha256sum "$FILE" > "$FILE.sha256"
  gpg --armor --detach-sign "$FILE"
done
