#!/bin/sh
# October and November 2024 Android & LineageOS security patches

export BASEDIR=~/android/lineage-20.0/

merge_upstream() {
  echo "$1"
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
cd ~/android/lineage-20.0/

# October & November 2024
merge_upstream frameworks/base

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream packages/modules/Wifi

# November 2024
merge_upstream vendor/lineage

# The following commits as part of the October updates broke gts28ltexx RIL, reverting
cd ~/android/lineage-20.0/vendor/lineage
git revert d38b35f32cb38bc67bdb052e37dc6b928198f53c
git rm overlay/wifionly/packages/apps/Settings/res/values/config.xml
git revert --continue
git revert c06535a42bf75f42281502174c6da88d8d5f2dc4
git rm overlay/wifionly/frameworks/base/core/res/res/values/config.xml
git revert --continue

cd $BASEDIR
