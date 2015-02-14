#!/bin/bash

base=$(readlink -f $(dirname $(dirname $0)))

function update_module {
  m=$1
  pushd $m > /dev/null
  echo $(basename $m)
  branch=$(git status | grep -E '^On branch' | sed 's/^On branch //')
  if [ "${branch}" != "master" ]; then
    git checkout master
  fi
  git pull -q
  popd > /dev/null
}

for m in $base/modules/ibox $base/modules/public/*; do
  update_module $m
done
