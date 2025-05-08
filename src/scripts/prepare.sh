#!/bin/sh

npx clean-package

./dist/scripts/sign.terball.sh $1
