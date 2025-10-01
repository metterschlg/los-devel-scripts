#!/bin/sh
# September 2025 Android & LineageOS security patches

export BASEDIR=~/android/lineage-21.0/

merge_upstream() {
  echo -e "\n=== $1 ==="
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

# April & May & June 2025 & August 2025 & September 2025
merge_upstream frameworks/base
# April 2025 & September 2025
merge_upstream frameworks/native
# April & May & June 2025 & September 2025
merge_upstream packages/modules/Bluetooth
# April 2025 & September 2025
merge_upstream packages/services/Telephony
# June 2025 & September 2025
merge_upstream art
# June 2025 & September 2025
merge_upstream frameworks/av
# August 2025 & September 2025
merge_upstream vendor/lineage
# September 2025
merge_upstream frameworks/opt/telephony

# June 2025 - track LineageOS forks for packages/apps/ManagedProvisioning
cat <<EOF>/tmp/manifest.patch
diff --git a/default.xml b/default.xml
index 4803dd4..4a47c17 100644
--- a/default.xml
+++ b/default.xml
@@ -1033,7 +1033,7 @@
   <project path="packages/apps/HTMLViewer" name="platform/packages/apps/HTMLViewer" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/ImsServiceEntitlement" name="platform/packages/apps/ImsServiceEntitlement" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/KeyChain" name="platform/packages/apps/KeyChain" groups="pdk-fs" remote="aosp" />
-  <project path="packages/apps/ManagedProvisioning" name="platform/packages/apps/ManagedProvisioning" groups="pdk-fs" remote="aosp" />
+  <project path="packages/apps/ManagedProvisioning" name="LineageOS/android_packages_apps_ManagedProvisioning" groups="pdk-fs" />
   <project path="packages/apps/Messaging" name="LineageOS/android_packages_apps_Messaging" groups="pdk-fs" />
   <project path="packages/apps/Music" name="platform/packages/apps/Music" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/MusicFX" name="platform/packages/apps/MusicFX" groups="pdk-fs" remote="aosp" />
EOF
git -C .repo/manifests apply /tmp/manifest.patch
repo sync --force-sync packages/apps/ManagedProvisioning

# September 2025 - track LineageOS forks for packages/modules/CellBroadcastService
cat <<EOF>/tmp/manifest.patch
diff --git a/default.xml b/default.xml
index 4803dd4..89e7157 100644
--- a/default.xml
+++ b/default.xml
@@ -1070,7 +1070,7 @@
   <project path="packages/modules/ArtPrebuilt" name="platform/packages/modules/ArtPrebuilt" groups="pdk" clone-depth="1" remote="aosp" />
   <!--<project path="packages/modules/Bluetooth" name="LineageOS/android_packages_modules_Bluetooth" groups="pdk" />-->
   <project path="packages/modules/CaptivePortalLogin" name="platform/packages/modules/CaptivePortalLogin" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
-  <project path="packages/modules/CellBroadcastService" name="platform/packages/modules/CellBroadcastService" groups="pdk" remote="aosp" />
+  <project path="packages/modules/CellBroadcastService" name="LineageOS/android_packages_modules_CellBroadcastService" groups="pdk" />
   <project path="packages/modules/common" name="LineageOS/android_packages_modules_common" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/modules/ConfigInfrastructure" name="platform/packages/modules/ConfigInfrastructure" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <!--<project path="packages/modules/Connectivity" name="LineageOS/android_packages_modules_Connectivity" groups="pdk-cw-fs,pdk-fs" />-->
EOF
git -C .repo/manifests apply /tmp/manifest.patch
repo sync --force-sync packages/modules/CellBroadcastService

# Fix ADB Breakage post QPR1 by reverting to QPR1 tree
echo -e "\n=== packages/modules/adb ==="
repo sync --force-sync packages/modules/adb
cd packages/modules/adb
git fetch --unshallow losul
git checkout remotes/losul/lineage-21.0-qpr1
cd $BASEDIR
