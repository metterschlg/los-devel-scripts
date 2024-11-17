#!/bin/sh
# October & November 2024 Android & LineageOS security patches

export BASEDIR=~/android/lineage-21.0/

merge_upstream() {
  echo "$1"
  cd $1
  # As we originally checked out with --depth=1 we need the full trees now to be able to merge
  git fetch --unshallow losul
  REPO_URL=${1//\//_}
  UPSTREAM=`git remote | grep upstream`
  if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_$REPO_URL
  fi
  git fetch upstream
  git merge remotes/upstream/lineage-21.0
  cd $BASEDIR
}

export GIT_EDITOR='true git commit'
cd $BASEDIR

# October 2024 & November 2024
merge_upstream frameworks/base

# October 2024
merge_upstream system/core

# October 2024 & November 2024
merge_upstream device/lineage/sepolicy

# October 2024 & November 2024
merge_upstream vendor/lineage

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream system/netd

# November 2024
merge_upstream packages/modules/Connectivity

# November 2024
merge_upstream frameworks/native

# TODO: verify if the following patches are required for LineageOS 21

## The following commits as part of the October updates broke gts28ltexx RIL, reverting
#cd vendor/lineage
## https://github.com/LineageOS-UL/android_vendor_lineage/commit/eaa2614343ac62523b6e8f0aeba6ca9adb0c837e
#git revert eaa2614343ac62523b6e8f0aeba6ca9adb0c837e
#git rm overlay/wifionly/packages/apps/Settings/res/values/config.xml
#git revert --continue

## https://github.com/LineageOS-UL/android_vendor_lineage/commit/9a0a021c7edbdc3924e0d2bea68540cd19c7b29e
#git revert 9a0a021c7edbdc3924e0d2bea68540cd19c7b29e
#git rm overlay/wifionly/frameworks/base/core/res/res/values/config.xml
#git revert --continue
#cd ~/android/lineage-21.0/
