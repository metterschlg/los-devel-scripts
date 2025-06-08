#!/bin/sh
# May 2025 Android & LineageOS security patches

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

# April & May 2025
merge_upstream frameworks/base
# April & May 2025
merge_upstream packages/modules/Bluetooth
# May 2025
merge_upstream packages/modules/Wifi

# April & May 2025 own fork tracking
cat <<EOF>/tmp/android-fork-tracking.patch
--- a/default.xml
+++ b/default.xml
@@ -173,7 +173,7 @@
   <project path="external/fmtlib" name="platform/external/fmtlib" groups="pdk" remote="aosp" />
   <project path="external/fonttools" name="platform/external/fonttools" groups="pdk" remote="aosp" />
   <project path="external/FP16" name="platform/external/FP16" groups="pdk" remote="aosp" />
-  <project path="external/freetype" name="platform/external/freetype" groups="pdk" remote="aosp" />
+  <project path="external/freetype" name="LineageOS/android_external_freetype" groups="pdk" />
   <project path="external/fsck_msdos" name="platform/external/fsck_msdos" groups="pdk" remote="aosp" />
   <project path="external/fsverity-utils" name="platform/external/fsverity-utils" groups="pdk" remote="aosp" />
   <project path="external/FXdiv" name="platform/external/FXdiv" groups="pdk" remote="aosp" />
@@ -926,7 +926,7 @@
   <project path="packages/modules/ExtServices" name="platform/packages/modules/ExtServices" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/modules/GeoTZ" name="platform/packages/modules/GeoTZ" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/modules/Gki" name="platform/packages/modules/Gki" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
-  <project path="packages/modules/IntentResolver" name="platform/packages/modules/IntentResolver" groups="pdk" remote="aosp" />
+  <project path="packages/modules/IntentResolver" name="LineageOS/android_packages_modules_IntentResolver" groups="pdk" />
   <project path="packages/modules/IPsec" name="platform/packages/modules/IPsec" groups="pdk" remote="aosp" />
   <project path="packages/modules/Media" name="platform/packages/modules/Media" groups="pdk" remote="aosp" />
   <project path="packages/modules/ModuleMetadata" name="platform/packages/modules/ModuleMetadata" groups="pdk" remote="aosp" />
EOF
git -C .repo/manifests apply /tmp/android-fork-tracking.patch
repo sync --force-sync external/freetype
repo sync --force-sync packages/modules/IntentResolver
