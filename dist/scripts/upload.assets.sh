#!/bin/sh

. ~/.profile

TAG=$1

for ASSET in "$TERBAL" "$TAG.zip" "$TAG.tar.gz"; do
  for EXT in sha256 asc; do
    gh release upload $TAG "$ASSET.$EXT"
  done
done

gh release upload $TAG "$TERBAL"
