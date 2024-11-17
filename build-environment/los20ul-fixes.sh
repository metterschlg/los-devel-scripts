#!/bin/sh
# October and November 2024 Android & LineageOS security patches

export GIT_EDITOR='true git commit'
cd ~/android/lineage-20.0/

# October & November 2024
cd frameworks/base
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_frameworks_base
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# October 2024
cd ~/android/lineage-20.0/
cd packages/modules/Bluetooth
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Bluetooth
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# November 2024
cd ~/android/lineage-20.0/
cd packages/modules/Wifi
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Wifi
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# November 2024
cd ~/android/lineage-20.0/
cd vendor/lineage
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_vendor_lineage
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# The following commits as part of the October updates broke gts28ltexx RIL, reverting
cd ~/android/lineage-20.0/vendor/lineage
git revert d38b35f32cb38bc67bdb052e37dc6b928198f53c
git rm overlay/wifionly/packages/apps/Settings/res/values/config.xml
git revert --continue
git revert c06535a42bf75f42281502174c6da88d8d5f2dc4
git rm overlay/wifionly/frameworks/base/core/res/res/values/config.xml
git revert --continue

cd ~/android/lineage-20.0/
