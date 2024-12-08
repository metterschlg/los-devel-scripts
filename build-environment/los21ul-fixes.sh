#!/bin/sh
# October-December 2024 Android & LineageOS security patches

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

# For some reason I do not yet understand, the manifests in android/ and .repo/manifests differ
# Switch to LineageOS repos for android_build_release, android_external_skia and android_hardware_google_camera
echo -e "\n=== .repo/manifests ==="
cd .repo/manifests
cat <<EOF>/tmp/default_xml_repos.patch
diff --git a/default.xml b/default.xml
index 83dacca..bbcd72e 100644
--- a/default.xml
+++ b/default.xml
@@ -45,7 +45,7 @@
   <project path="build/bazel_common_rules" name="platform/build/bazel_common_rules" groups="pdk" remote="aosp" />
   <project path="build/blueprint" name="platform/build/blueprint" groups="pdk,tradefed" remote="aosp" />
   <project path="build/pesto" name="platform/build/pesto" groups="pdk" remote="aosp" />
-  <project path="build/release" name="platform/build/release" groups="pdk,tradefed" remote="aosp" />
+  <project path="build/release" name="LineageOS/android_build_release" groups="pdk,tradefed" />
   <project path="build/soong" name="LineageOS-UL/android_build_soong" groups="pdk,tradefed" >
     <linkfile src="root.bp" dest="Android.bp" />
     <linkfile src="bootstrap.bash" dest="bootstrap.bash" />
@@ -809,7 +809,7 @@
   <project path="external/sg3_utils" name="platform/external/sg3_utils" groups="pdk" remote="aosp" />
   <project path="external/shaderc/spirv-headers" name="platform/external/shaderc/spirv-headers" groups="pdk" remote="aosp" />
   <project path="external/shflags" name="platform/external/shflags" groups="pdk" remote="aosp" />
-  <project path="external/skia" name="platform/external/skia" groups="pdk,qcom_msm8x26" remote="aosp" />
+  <project path="external/skia" name="LineageOS/android_external_skia" groups="pdk,qcom_msm8x26" />
   <project path="external/sl4a" name="platform/external/sl4a" groups="pdk" remote="aosp" />
   <project path="external/slf4j" name="platform/external/slf4j" groups="pdk" remote="aosp" />
   <project path="external/snakeyaml" name="platform/external/snakeyaml" groups="pdk" remote="aosp" />
@@ -917,7 +917,7 @@
   <project path="hardware/google/aemu" name="platform/hardware/google/aemu" groups="pdk" remote="aosp" />
   <project path="hardware/google/apf" name="platform/hardware/google/apf" groups="pdk" remote="aosp" />
   <project path="hardware/google/av" name="platform/hardware/google/av" groups="pdk" remote="aosp" />
-  <project path="hardware/google/camera" name="platform/hardware/google/camera" groups="pdk" remote="aosp" />
+  <project path="hardware/google/camera" name="LineageOS/android_hardware_google_camera" groups="pdk" />
   <project path="hardware/google/easel" name="platform/hardware/google/easel" groups="pdk,easel" remote="aosp" />
   <project path="hardware/google/gchips" name="LineageOS/android_hardware_google_gchips" groups="pdk-lassen,pdk-gs-arm" />
   <project path="hardware/google/gfxstream" name="platform/hardware/google/gfxstream" groups="pdk" remote="aosp" />
EOF
git apply /tmp/default_xml_repos.patch
rm /tmp/default_xml_repos.patch
cd $BASEDIR
repo sync --force-sync external/skia
repo sync --force-sync hardware/google/camera
repo sync --force-sync build/release

# October-December 2024
merge_upstream frameworks/base

# October 2024
merge_upstream system/core

# October 2024 & November 2024
merge_upstream device/lineage/sepolicy
cd device/lineage/sepolicy
git add common/vendor/file_contexts
git merge --continue
cd $BASEDIR

# October 2024 & November 2024
merge_upstream vendor/lineage
cd vendor/lineage
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
git apply /tmp/vendor_lineage_build_soong_Android_bp.patch
git add build/soong/Android.bp
git merge --continue
rm /tmp/vendor_lineage_build_soong_Android_bp.patch
cd $BASEDIR

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream system/netd

# November 2024
merge_upstream packages/modules/Connectivity

# November-December 2024
merge_upstream frameworks/native

# December 2024
merge_upstream frameworks/base

echo -e "\n=== android ==="
cd android
git checkout default.xml
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
EOF
patch -p0 < /tmp/default_xml_adb.patch
rm /tmp/default_xml_adb.patch
cd $BASEDIR

echo -e "\n=== packages/modules/adb ==="
repo sync --force-sync packages/modules/adb
cd packages/modules/adb
git fetch --unshallow losul
git checkout remotes/losul/lineage-21.0-qpr1
cd $BASEDIR
