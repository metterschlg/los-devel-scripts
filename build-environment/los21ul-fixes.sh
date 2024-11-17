#!/bin/sh
# October & November 2024 Android & LineageOS security patches

export GIT_EDITOR='true git commit'

cd ~/android/lineage-21.0/

# October 2024 & November 2024
cd frameworks/base
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_frameworks_base
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# October 2024
cd system/core
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_system_core
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# October 2024 & November 2024
cd device/lineage/sepolicy
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_device_lineage_sepolicy
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# October 2024 & November 2024
cd vendor/lineage
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_vendor_lineage
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# October 2024
cd packages/modules/Bluetooth
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Bluetooth
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# November 2024
cd system/netd
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_system_netd
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# November 2024
cd packages/modules/Connectivity
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Connectivity
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

# November 2024
cd frameworks/native
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_frameworks_native
fi
git fetch upstream
git merge remotes/upstream/lineage-21.0
cd ~/android/lineage-21.0/

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
