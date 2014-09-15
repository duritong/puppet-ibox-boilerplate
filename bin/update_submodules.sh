#!/bin/bash

base=$(readlink -f $(dirname $(dirname $0)))

pushd $base/modules/ibox > /dev/null
git checkout master
git pull
popd > /dev/null

for m in modules/public/*; do
  pushd $m > /dev/null
  git checkout master
  git pull
  popd > /dev/null
done
