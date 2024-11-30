#!/bin/sh
# October & November 2024 Android & LineageOS security patches

export BASEDIR=~/android/lineage-21.0/

merge_upstream() {
  echo "=== $1 ==="
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
# The fixes to this tree create a merge conflict, resolve manually
cat <<EOF>>/tmp/device_lineage_sepolicy_mergefix.patch
--- file_contexts.mergeconflict	2024-11-23 12:54:32.542181252 +0100
+++ file_contexts	2024-11-23 12:54:57.223877846 +0100
@@ -33,10 +33,7 @@
 
 # Vibrator HAL
 /(vendor|system/vendor)/bin/hw/android\.hardware\.vibrator@1\.0-service\.lineage u:object_r:hal_vibrator_default_exec:s0
-<<<<<<< HEAD
+/(vendor|system/vendor)/bin/hw/android\.hardware\.vibrator-service\.legacy       u:object_r:hal_vibrator_default_exec:s0
 
 # Wi-Fi HAL
 /(vendor|system/vendor)/bin/hw/android\.hardware\.wifi@1\.0-service\.legacy u:object_r:hal_wifi_default_exec:s0
-=======
-/(vendor|system/vendor)/bin/hw/android\.hardware\.vibrator-service\.legacy       u:object_r:hal_vibrator_default_exec:s0
->>>>>>> remotes/upstream/lineage-21.0
EOF
cd device/lineage/sepolicy/common/vendor/
patch -p0 < /tmp/device_lineage_sepolicy_mergefix.patch
git add file_contexts
git merge --continue
rm /tmp/device_lineage_sepolicy_mergefix.patch
cd $BASEDIR

# October 2024 & November 2024
merge_upstream vendor/lineage
cd vendor/lineage/build/soong/
cat <<EOF>>/tmp/vendor_lineage_build_soong_Android_bp.patch
diff --git a/build/soong/Android.bp b/build/soong/Android.bp
index 1e2832d9..f8bf4429 100644
--- a/build/soong/Android.bp
+++ b/build/soong/Android.bp
@@ -642,6 +642,7 @@ stagefright_qcom_legacy {
         uses_qcom_bsp_legacy: {
             cppflags: ["-DQCOM_BSP_LEGACY"],
         },
+    }
 }
 
 soong_config_module_type {
EOF
patch -p0 < /tmp/vendor_lineage_build_soong_Android_bp.patch
git add Android.bp
git merge --continue
rm /tmp/vendor_lineage_build_soong_Android_bp.patch
cd $BASEDIR

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream system/netd

# November 2024
merge_upstream packages/modules/Connectivity

# November 2024
merge_upstream frameworks/native

# ADB got broken with QPR2, switch back to QPR1
cat <<EOF>>/tmp/default_xml_adb.patch
--- default.xml.orig	2024-11-30 12:32:49.227755105 +0100
+++ default.xml	2024-11-30 12:32:44.171653848 +0100
@@ -1058,7 +1058,7 @@
   <project path="packages/apps/WallpaperPicker2" name="LineageOS/android_packages_apps_WallpaperPicker2" groups="pdk-fs,sysui-studio" />
   <project path="packages/inputmethods/LatinIME" name="LineageOS/android_packages_inputmethods_LatinIME" groups="pdk-fs" />
   <project path="packages/inputmethods/LeanbackIME" name="LineageOS/android_packages_inputmethods_LeanbackIME" groups="pdk-fs" />
-  <project path="packages/modules/adb" name="LineageOS/android_packages_modules_adb" groups="pdk" />
+  <project path="packages/modules/adb" name="LineageOS-UL/android_packages_modules_adb" remote="losul" revision="lineage-21.0-qpr1" />
   <project path="packages/modules/AdServices" name="platform/packages/modules/AdServices" groups="pdk-cw-fs,pdk-fs,sysui-studio" remote="aosp" />
   <project path="packages/modules/AppSearch" name="platform/packages/modules/AppSearch" groups="pdk" remote="aosp" />
   <project path="packages/modules/ArtPrebuilt" name="platform/packages/modules/ArtPrebuilt" groups="pdk" clone-depth="1" remote="aosp" />
cd android
patch -p0 < /tmp/default_xml_adb.patch
cd $BASEDIR
