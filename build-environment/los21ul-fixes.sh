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
git commit --continue
rm /tmp/device_lineage_sepolicy_mergefix.patch
cd $BASEDIR

# October 2024 & November 2024
merge_upstream vendor/lineage
# The fixes to this tree create a merge conflict, resolve manually
cat <<EOF>/tmp/vendor_lineage_mergefix.patch
--- Android.bp.mergeconflict	2024-11-23 13:57:38.848945499 +0100
+++ Android.bp	2024-11-23 14:11:40.905406782 +0100
@@ -629,7 +629,6 @@
 }
 
 soong_config_module_type {
-<<<<<<< HEAD
     name: "stagefright_qcom_legacy",
     module_type: "cc_defaults",
     config_namespace: "lineageQcomVars",
@@ -642,7 +641,11 @@
     soong_config_variables: {
         uses_qcom_bsp_legacy: {
             cppflags: ["-DQCOM_BSP_LEGACY"],
-=======
+        },
+    },
+}
+
+soong_config_module_type {
     name: "qcom_libfmjni",
     module_type: "cc_defaults",
     config_namespace: "lineageQcomVars",
@@ -655,7 +658,6 @@
     soong_config_variables: {
         no_fm_firmware: {
             cflags: ["-DQCOM_NO_FM_FIRMWARE"],
->>>>>>> remotes/upstream/lineage-21.0
         },
     },
 }
EOF
cd vendor/lineage/build/soong/
patch -p0 < /tmp/vendor_lineage_mergefix.patch
git add Android.bp
git commit --continue
rm /tmp/vendor_lineage_mergefix.patch
cd $BASEDIR

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream system/netd

# November 2024
merge_upstream packages/modules/Connectivity

# November 2024
merge_upstream frameworks/native
