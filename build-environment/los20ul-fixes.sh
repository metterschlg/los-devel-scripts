#!/bin/sh
# October 2024 Android & LineageOS security patch
#repopick -f -t T_asb_2024-10

# android_frameworks_base
#Applying change number 405358...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.
#Applying change number 405359...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.
#Applying change number 405360...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.
#Applying change number 405361...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.
export GIT_EDITOR='true git commit'
cd ~/android/lineage-20.0/
cd frameworks/base
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_frameworks_base
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# android_libcore (already merged as not in lineageos-ul)
#Applying change number 405362...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.

# android_packages_apps_Settings (already merged as not in lineageos-ul)
#Applying change number 405363...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.

# android_packages_modules_Bluetooth
#Applying change number 405364...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.
cd ~/android/lineage-20.0/
cd packages/modules/Bluetooth
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Bluetooth
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0

# android_build (already merged as not in lineageos-ul)
#Applying change number 405365...
#Change status is MERGED. Skipping the cherry pick.
#Use -f to force this pick.

# The following commits as part of the October updates broke gts28ltexx RIL, reverting
cd ~/android/lineage-20.0/vendor/lineage
git revert d38b35f32cb38bc67bdb052e37dc6b928198f53c
git rm overlay/wifionly/packages/apps/Settings/res/values/config.xml
git revert --continue
git revert c06535a42bf75f42281502174c6da88d8d5f2dc4
git rm overlay/wifionly/frameworks/base/core/res/res/values/config.xml
git revert --continue

cd ~/android/lineage-20.0/
