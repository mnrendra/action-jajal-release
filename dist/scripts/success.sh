#!/bin/sh

npx clean-package restore

./dist/scripts/sign.assets.sh $1 $2

./dist/scripts/upload.assets.sh $1
