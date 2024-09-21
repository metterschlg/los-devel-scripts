#!/bin/sh
GIT_EDITOR='true git commit'
# June 2024
cd ~/android/lineage-20.0/
cd frameworks/base
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
    git remote add upstream https://github.com/LineageOS/android_frameworks_base
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0
# July 2024
cd ~/android/lineage-20.0/
cd packages/modules/Bluetooth
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_packages_modules_Bluetooth
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0
# August 2024
cd ~/android/lineage-20.0/
cd hardware/interfaces/
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_hardware_interfaces
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0
cd ~/android/lineage-20.0/
cd frameworks/av/
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_frameworks_av
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0
# September 2024
cd ~/android/lineage-20.0/
cd system/sepolicy
UPSTREAM=`git remote | grep upstream`
if [ x${UPSTREAM} == "x" ]; then
  git remote add upstream  https://github.com/LineageOS/android_system_sepolicy
fi
git fetch upstream
git merge remotes/upstream/lineage-20.0
cd ~/android/lineage-20.0/
