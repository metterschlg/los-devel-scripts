#!/bin/sh
# March 2026 Android & LineageOS security patches

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

# April & May & June & August & September & December 2025 & March 2026
merge_upstream frameworks/base
# April 2025 & September 2025 & December 2025 & March 2026
merge_upstream frameworks/native
# September 2025 & December 2025
merge_upstream frameworks/opt/telephony
# April & May & June & September & November & December 2025
merge_upstream packages/modules/Bluetooth
# April 2025 & September 2025 & December 2025
merge_upstream packages/services/Telephony
# June 2025 & September 2025
merge_upstream art
# June 2025 & September 2025 & March 2026
merge_upstream frameworks/av
# August 2025 & September 2025 & December 2025
merge_upstream vendor/lineage

# June 2025 - track LineageOS forks for
#                 packages/apps/ManagedProvisioning
# September 2025 - track LineageOS forks for
#                 packages/modules/CellBroadcastService
# December 2025 - track LineageOS forks for
#                 external/sqlite
#                 packages/apps/CertInstaller
#                 vendor/apn
# March 2026 - track LineageOS forks for
#              external/cldr
#              external/dng_sdk
#              external/icu
#              packages/modules/Virtualization
#              system/timezone
cat <<EOF>/tmp/default-manifest.patch
diff --git a/default.xml b/default.xml
index 4803dd4..70ad194 100644
--- a/default.xml
+++ b/default.xml
@@ -136,7 +136,7 @@
   <project path="external/cbor-java" name="platform/external/cbor-java" groups="pdk" remote="aosp" />
   <project path="external/chromium-trace" name="platform/external/chromium-trace" groups="pdk" remote="aosp" />
   <project path="external/clang" name="platform/external/clang" groups="pdk" remote="aosp" />
-  <project path="external/cldr" name="platform/external/cldr" groups="pdk" remote="aosp" />
+  <project path="external/cldr" name="LineageOS/android_external_cldr" groups="pdk" />
   <project path="external/cn-cbor" name="platform/external/cn-cbor" groups="pdk" remote="aosp" />
   <project path="external/compiler-rt" name="platform/external/compiler-rt" groups="pdk" remote="aosp" />
   <project path="external/ComputeLibrary" name="platform/external/ComputeLibrary" groups="pdk-lassen,pdk-gs-arm" remote="aosp" />
@@ -235,7 +235,7 @@
   <project path="external/horologist" name="platform/external/horologist" groups="pdk" remote="aosp" />
   <project path="external/hyphenation-patterns" name="platform/external/hyphenation-patterns" groups="pdk" remote="aosp" />
   <project path="external/icing" name="platform/external/icing" groups="pdk" remote="aosp" />
-  <project path="external/icu" name="platform/external/icu" groups="pdk" remote="aosp" />
+  <project path="external/icu" name="LineageOS/android_external_icu" groups="pdk" />
   <project path="external/igt-gpu-tools" name="platform/external/igt-gpu-tools" groups="pdk" remote="aosp" />
   <project path="external/ImageMagick" name="platform/external/ImageMagick" groups="pdk" remote="aosp" />
   <project path="external/image_io" name="platform/external/image_io" groups="pdk" remote="aosp" />
@@ -816,7 +816,7 @@
   <project path="external/sonic" name="platform/external/sonic" groups="pdk" remote="aosp" />
   <project path="external/sonivox" name="platform/external/sonivox" groups="pdk" remote="aosp" />
   <project path="external/speex" name="platform/external/speex" groups="pdk" remote="aosp" />
-  <project path="external/sqlite" name="platform/external/sqlite" groups="pdk" remote="aosp" />
+  <project path="external/sqlite" name="LineageOS/android_external_sqlite" groups="pdk" />
   <project path="external/spdx-tools" name="platform/external/spdx-tools" groups="pdk" remote="aosp" />
   <project path="external/squashfs-tools" name="platform/external/squashfs-tools" groups="pdk" remote="aosp" />
   <project path="external/stardoc" name="platform/external/stardoc" groups="pdk" remote="aosp" />
@@ -1025,7 +1025,7 @@
   <project path="packages/apps/Car/SystemUpdater" name="platform/packages/apps/Car/SystemUpdater" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/CarrierConfig" name="platform/packages/apps/CarrierConfig" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/apps/CellBroadcastReceiver" name="LineageOS/android_packages_apps_CellBroadcastReceiver" groups="pdk-cw-fs,pdk-fs" />
-  <project path="packages/apps/CertInstaller" name="platform/packages/apps/CertInstaller" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
+  <project path="packages/apps/CertInstaller" name="LineageOS/android_packages_apps_CertInstaller" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/apps/Contacts" name="LineageOS/android_packages_apps_Contacts" groups="pdk-fs" />
   <project path="packages/apps/Dialer" name="LineageOS/android_packages_apps_Dialer" groups="pdk-fs" />
   <project path="packages/apps/DocumentsUI" name="LineageOS/android_packages_apps_DocumentsUI" groups="pdk-cw-fs,pdk-fs" />
@@ -1033,7 +1033,7 @@
   <project path="packages/apps/HTMLViewer" name="platform/packages/apps/HTMLViewer" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/ImsServiceEntitlement" name="platform/packages/apps/ImsServiceEntitlement" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/KeyChain" name="platform/packages/apps/KeyChain" groups="pdk-fs" remote="aosp" />
-  <project path="packages/apps/ManagedProvisioning" name="platform/packages/apps/ManagedProvisioning" groups="pdk-fs" remote="aosp" />
+  <project path="packages/apps/ManagedProvisioning" name="LineageOS/android_packages_apps_ManagedProvisioning" groups="pdk-fs" />
   <project path="packages/apps/Messaging" name="LineageOS/android_packages_apps_Messaging" groups="pdk-fs" />
   <project path="packages/apps/Music" name="platform/packages/apps/Music" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/MusicFX" name="platform/packages/apps/MusicFX" groups="pdk-fs" remote="aosp" />
@@ -1070,7 +1070,7 @@
   <project path="packages/modules/ArtPrebuilt" name="platform/packages/modules/ArtPrebuilt" groups="pdk" clone-depth="1" remote="aosp" />
   <!--<project path="packages/modules/Bluetooth" name="LineageOS/android_packages_modules_Bluetooth" groups="pdk" />-->
   <project path="packages/modules/CaptivePortalLogin" name="platform/packages/modules/CaptivePortalLogin" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
-  <project path="packages/modules/CellBroadcastService" name="platform/packages/modules/CellBroadcastService" groups="pdk" remote="aosp" />
+  <project path="packages/modules/CellBroadcastService" name="LineageOS/android_packages_modules_CellBroadcastService" groups="pdk" />
   <project path="packages/modules/common" name="LineageOS/android_packages_modules_common" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/modules/ConfigInfrastructure" name="platform/packages/modules/ConfigInfrastructure" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <!--<project path="packages/modules/Connectivity" name="LineageOS/android_packages_modules_Connectivity" groups="pdk-cw-fs,pdk-fs" />-->
@@ -1104,7 +1104,7 @@
   <project path="packages/modules/ThreadNetwork" name="platform/packages/modules/ThreadNetwork" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/modules/Uwb" name="platform/packages/modules/Uwb" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/modules/UprobeStats" name="platform/packages/modules/UprobeStats" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
-  <project path="packages/modules/Virtualization" name="platform/packages/modules/Virtualization" groups="pdk" remote="aosp" />
+  <project path="packages/modules/Virtualization" name="LineageOS/android_packages_modules_Virtualization" groups="pdk" />
   <project path="packages/modules/vndk" name="platform/packages/modules/vndk" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/modules/Wifi" name="LineageOS/android_packages_modules_Wifi" groups="pdk-cw-fs,pdk-fs,sysui-studio" />
   <project path="packages/providers/BlockedNumberProvider" name="LineageOS/android_packages_providers_BlockedNumberProvider" groups="pdk-fs" />
@@ -1250,7 +1250,7 @@
   <project path="system/server_configurable_flags" name="platform/system/server_configurable_flags" groups="pdk" remote="aosp" />
   <project path="system/teeui" name="platform/system/teeui" groups="pdk" remote="aosp" />
   <project path="system/testing/gtest_extras" name="platform/system/testing/gtest_extras" groups="pdk" remote="aosp" />
-  <project path="system/timezone" name="platform/system/timezone" groups="pdk" remote="aosp" />
+  <project path="system/timezone" name="LineageOS/android_system_timezone" groups="pdk" />
   <project path="system/tools/aidl" name="platform/system/tools/aidl" groups="pdk" remote="aosp" />
   <project path="system/tools/hidl" name="platform/system/tools/hidl" groups="pdk" remote="aosp" />
   <project path="system/tools/mkbootimg" name="LineageOS/android_system_tools_mkbootimg" groups="pdk" />
EOF
cat <<EOF>/tmp/lineage-manifest.patch
diff --git a/snippets/lineage.xml b/snippets/lineage.xml
index 05142b8..251527c 100644
--- a/snippets/lineage.xml
+++ b/snippets/lineage.xml
@@ -55,6 +55,7 @@
   <project path="packages/resources/devicesettings" name="LineageOS/android_packages_resources_devicesettings" />
   <project path="prebuilts/extract-tools" name="LineageOS/android_prebuilts_extract-tools" clone-depth="1" />
   <project path="tools/extract-utils" name="LineageOS/android_tools_extract-utils" />
+  <project path="vendor/apn" name="LineageOS/android_vendor_apn" revision="main" />
   <project path="vendor/crowdin" name="LineageOS/android_vendor_crowdin" />
   <!--<project path="vendor/lineage" name="LineageOS/android_vendor_lineage" />-->
 
EOF
git -C .repo/manifests apply /tmp/default-manifest.patch
git -C .repo/manifests apply /tmp/lineage-manifest.patch
repo sync --force-sync packages/apps/ManagedProvisioning
repo sync --force-sync packages/modules/CellBroadcastService
repo sync --force-sync external/sqlite
repo sync --force-sync packages/apps/CertInstaller
repo sync --force-sync vendor/apn
repo sync --force-sync external/cldr
repo sync --force-sync external/dng_sdk
repo sync --force-sync external/icu
repo sync --force-sync packages/modules/Virtualization
repo sync --force-sync system/timezone

# Fix ADB Breakage post QPR1 by reverting to QPR1 tree
echo -e "\n=== packages/modules/adb ==="
repo sync --force-sync packages/modules/adb
cd packages/modules/adb
git fetch --unshallow losul
git checkout remotes/losul/lineage-21.0-qpr1
cd $BASEDIR
