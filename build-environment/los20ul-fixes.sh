#!/bin/sh
# April 2025 Android & LineageOS security patches

export BASEDIR=~/android/lineage-20.0/

merge_upstream() {
  echo -e "\n=== $1 ==="
  cd $1
  # If we originally checked out with --depth=1 we need the full trees now to be able to merge
  git fetch --unshallow losul
  REPO_URL=${1//\//_}
  UPSTREAM=`git remote | grep upstream`
  if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_$REPO_URL
  fi
  git fetch upstream
  git merge remotes/upstream/lineage-20.0
  cd $BASEDIR
}

export GIT_EDITOR='true git commit'
cd $BASEDIR

# April 2025
merge_upstream frameworks/base
# April 2025
merge_upstream packages/modules/Bluetooth
