#!/bin/sh

. ~/.profile

VERSION=$1

for PACK in *-$VERSION.tgz; do
  echo "export TERBAL=$PACK" >> ~/.profile;
done

. ~/.profile

sha256sum "$TERBAL" > "$TERBAL.sha256"

gpg --armor --detach-sign "$TERBAL"
