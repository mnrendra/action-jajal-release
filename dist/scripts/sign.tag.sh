#!/bin/sh

TAG=$1
NOTE=$2

git tag -d $TAG

git push origin -d tag $TAG

git tag -s $TAG -m "release: $TAG\n\n$NOTE"

git push origin $TAG
