#!/bin/sh
# September 2026 Android & LineageOS security patches

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

# April & May & June & August & September & December 2025 & March 2026 & April 2026 & May 2026 & June 2026
# & September 2026
merge_upstream frameworks/base
# April 2025 & September 2025 & December 2025 & March 2026
merge_upstream frameworks/native
# September 2025 & December 2025 & May 2026 & September 2026
merge_upstream frameworks/opt/telephony
# April & May & June & September & November & December 2025 & June 2026 & September 2026
merge_upstream packages/modules/Bluetooth
# April 2025 & September 2025 & December 2025 & June 2026 & September 2026
merge_upstream packages/services/Telephony
# June 2025 & September 2025
merge_upstream art
# June 2025 & September 2025 & March 2026 & September 2026
merge_upstream frameworks/av
# August 2025 & September 2025 & December 2025 & May 2026
merge_upstream vendor/lineage
# September 2026
merge_upstream bionic
# September 2026
merge_upstream external/wpa_supplicant_8
# September 2026
merge_upstream hardware/interfaces

# June 2025 - track LineageOS forks for
#  packages/apps/ManagedProvisioning
# September 2025 - track LineageOS forks for
#  packages/modules/CellBroadcastService
# December 2025 - track LineageOS forks for
#  external/sqlite
#  packages/apps/CertInstaller
#  vendor/apn
# March 2026 - track LineageOS forks for
#  external/cldr
#  external/dng_sdk
#  external/icu
#  packages/modules/Virtualization
#  system/timezone
# May 2026 - track LineageOS forks for
#  external/expat
# June 2026 - track LineageOS forks for
#  packages/apps/KeyChain
# September 2026 - track LineageOS forks for
#  external/freetype
#  external/libhevc
#  packages/apps/TV
#  system/incremental_delivery
#  system/nfc
cat <<EOF>/tmp/manifest.patch
diff --git a/default.xml b/default.xml
index 4803dd4..49757e3 100644
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
@@ -176,7 +176,7 @@
   <project path="external/escapevelocity" name="platform/external/escapevelocity" groups="pdk" remote="aosp" />
   <project path="external/ethtool" name="platform/external/ethtool" groups="pdk" remote="aosp" />
   <project path="external/exoplayer" name="platform/external/exoplayer" groups="pdk" remote="aosp" />
-  <project path="external/expat" name="platform/external/expat" groups="pdk" remote="aosp" />
+  <project path="external/expat" name="LineageOS/android_external_expat" groups="pdk" />
   <project path="external/f2fs-tools" name="platform/external/f2fs-tools" groups="pdk" remote="aosp" />
   <project path="external/fastrpc" name="platform/external/fastrpc" groups="pdk" remote="aosp" />
   <project path="external/fdlibm" name="platform/external/fdlibm" groups="pdk" remote="aosp" />
@@ -189,7 +189,7 @@
   <project path="external/fmtlib" name="platform/external/fmtlib" groups="pdk" remote="aosp" />
   <project path="external/fonttools" name="platform/external/fonttools" groups="pdk" remote="aosp" />
   <project path="external/FP16" name="platform/external/FP16" groups="pdk" remote="aosp" />
-  <project path="external/freetype" name="platform/external/freetype" groups="pdk" remote="aosp" />
+  <project path="external/freetype" name="LineageOS/android_external_freetype" groups="pdk" />
   <project path="external/fsck_msdos" name="platform/external/fsck_msdos" groups="pdk" remote="aosp" />
   <project path="external/fsverity-utils" name="platform/external/fsverity-utils" groups="pdk" remote="aosp" />
   <project path="external/FXdiv" name="platform/external/FXdiv" groups="pdk" remote="aosp" />
@@ -235,7 +235,7 @@
   <project path="external/horologist" name="platform/external/horologist" groups="pdk" remote="aosp" />
   <project path="external/hyphenation-patterns" name="platform/external/hyphenation-patterns" groups="pdk" remote="aosp" />
   <project path="external/icing" name="platform/external/icing" groups="pdk" remote="aosp" />
-  <project path="external/icu" name="platform/external/icu" groups="pdk" remote="aosp" />
+  <project path="external/icu" name="LineageOS/android_external_icu" groups="pdk" />
   <project path="external/igt-gpu-tools" name="platform/external/igt-gpu-tools" groups="pdk" remote="aosp" />
   <project path="external/ImageMagick" name="platform/external/ImageMagick" groups="pdk" remote="aosp" />
   <project path="external/image_io" name="platform/external/image_io" groups="pdk" remote="aosp" />
@@ -302,7 +302,7 @@
   <project path="external/libfuse" name="platform/external/libfuse" groups="pdk" remote="aosp" />
   <project path="external/libgav1" name="platform/external/libgav1" groups="pdk" remote="aosp" />
   <project path="external/libgsm" name="platform/external/libgsm" groups="pdk" remote="aosp" />
-  <project path="external/libhevc" name="platform/external/libhevc" groups="pdk" remote="aosp" />
+  <project path="external/libhevc" name="LineageOS/android_external_libhevc" groups="pdk" />
   <project path="external/libiio" name="platform/external/libiio" groups="pdk" remote="aosp" />
   <project path="external/libjpeg-turbo" name="platform/external/libjpeg-turbo" groups="pdk" remote="aosp" />
   <project path="external/libkmsxx" name="platform/external/libkmsxx" groups="pdk" remote="aosp" />
@@ -318,7 +318,7 @@
   <project path="external/libpalmrejection" name="platform/external/libpalmrejection" groups="pdk" remote="aosp" />
   <project path="external/libpcap" name="platform/external/libpcap" groups="pdk" remote="aosp" />
   <project path="external/libphonenumber" name="platform/external/libphonenumber" groups="pdk" remote="aosp" />
-  <project path="external/libpng" name="platform/external/libpng" groups="pdk" remote="aosp" />
+  <project path="external/libpng" name="LineageOS/android_external_libpng" groups="pdk" />
   <project path="external/libprotobuf-mutator" name="platform/external/libprotobuf-mutator" groups="pdk" remote="aosp" />
   <project path="external/libsrtp2" name="platform/external/libsrtp2" groups="pdk" remote="aosp" />
   <project path="external/libtextclassifier" name="platform/external/libtextclassifier" groups="pdk" remote="aosp" />
@@ -816,7 +816,7 @@
   <project path="external/sonic" name="platform/external/sonic" groups="pdk" remote="aosp" />
   <project path="external/sonivox" name="platform/external/sonivox" groups="pdk" remote="aosp" />
   <project path="external/speex" name="platform/external/speex" groups="pdk" remote="aosp" />
-  <project path="external/sqlite" name="platform/external/sqlite" groups="pdk" remote="aosp" />
+  <project path="external/sqlite" name="LineageOS/android_external_sqlite" groups="pdk" />
   <project path="external/spdx-tools" name="platform/external/spdx-tools" groups="pdk" remote="aosp" />
   <project path="external/squashfs-tools" name="platform/external/squashfs-tools" groups="pdk" remote="aosp" />
   <project path="external/stardoc" name="platform/external/stardoc" groups="pdk" remote="aosp" />
@@ -1025,15 +1025,15 @@
   <project path="packages/apps/Car/SystemUpdater" name="platform/packages/apps/Car/SystemUpdater" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/CarrierConfig" name="platform/packages/apps/CarrierConfig" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/apps/CellBroadcastReceiver" name="LineageOS/android_packages_apps_CellBroadcastReceiver" groups="pdk-cw-fs,pdk-fs" />
-  <project path="packages/apps/CertInstaller" name="platform/packages/apps/CertInstaller" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
+  <project path="packages/apps/CertInstaller" name="LineageOS/android_packages_apps_CertInstaller" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/apps/Contacts" name="LineageOS/android_packages_apps_Contacts" groups="pdk-fs" />
   <project path="packages/apps/Dialer" name="LineageOS/android_packages_apps_Dialer" groups="pdk-fs" />
   <project path="packages/apps/DocumentsUI" name="LineageOS/android_packages_apps_DocumentsUI" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/apps/EmergencyInfo" name="LineageOS/android_packages_apps_EmergencyInfo" groups="pdk-fs" />
   <project path="packages/apps/HTMLViewer" name="platform/packages/apps/HTMLViewer" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/ImsServiceEntitlement" name="platform/packages/apps/ImsServiceEntitlement" groups="pdk-fs" remote="aosp" />
-  <project path="packages/apps/KeyChain" name="platform/packages/apps/KeyChain" groups="pdk-fs" remote="aosp" />
-  <project path="packages/apps/ManagedProvisioning" name="platform/packages/apps/ManagedProvisioning" groups="pdk-fs" remote="aosp" />
+  <project path="packages/apps/KeyChain" name="LineageOS/android_packages_apps_KeyChain" groups="pdk-fs" />
+  <project path="packages/apps/ManagedProvisioning" name="LineageOS/android_packages_apps_ManagedProvisioning" groups="pdk-fs" />
   <project path="packages/apps/Messaging" name="LineageOS/android_packages_apps_Messaging" groups="pdk-fs" />
   <project path="packages/apps/Music" name="platform/packages/apps/Music" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/MusicFX" name="platform/packages/apps/MusicFX" groups="pdk-fs" remote="aosp" />
@@ -1059,7 +1059,7 @@
   <project path="packages/apps/TvFeedbackConsent" name="platform/packages/apps/TvFeedbackConsent" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/TvSettings" name="LineageOS/android_packages_apps_TvSettings" groups="pdk-fs" />
   <project path="packages/apps/TvSystemUI" name="LineageOS/android_packages_apps_TvSystemUI" groups="pdk-fs" />
-  <project path="packages/apps/TV" name="platform/packages/apps/TV" groups="pdk" remote="aosp" />
+  <project path="packages/apps/TV" name="LineageOS/android_packages_apps_TV" groups="pdk" />
   <project path="packages/apps/UniversalMediaPlayer" name="platform/packages/apps/UniversalMediaPlayer" remote="aosp" />
   <project path="packages/apps/WallpaperPicker2" name="LineageOS/android_packages_apps_WallpaperPicker2" groups="pdk-fs,sysui-studio" />
   <project path="packages/inputmethods/LatinIME" name="LineageOS/android_packages_inputmethods_LatinIME" groups="pdk-fs" />
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
@@ -1216,7 +1216,7 @@
   <project path="system/gsid" name="platform/system/gsid" groups="pdk" remote="aosp" />
   <project path="system/hardware/interfaces" name="platform/system/hardware/interfaces" groups="pdk,sysui-studio" remote="aosp" />
   <project path="system/hwservicemanager" name="platform/system/hwservicemanager" groups="pdk" remote="aosp" />
-  <project path="system/incremental_delivery" name="platform/system/incremental_delivery" groups="pdk" remote="aosp" />
+  <project path="system/incremental_delivery" name="LineageOS/android_system_incremental_delivery" groups="pdk" />
   <project path="system/iorap" name="platform/system/iorap" groups="pdk" remote="aosp" />
   <project path="system/keymaster" name="LineageOS/android_system_keymaster" groups="pdk" />
   <project path="system/keymint" name="LineageOS/android_system_keymint" groups="pdk" />
@@ -1242,7 +1242,7 @@
   <project path="system/memory/libmemunreachable" name="platform/system/memory/libmemunreachable" groups="pdk" remote="aosp" />
   <project path="system/memory/lmkd" name="platform/system/memory/lmkd" groups="pdk" remote="aosp" />
   <!--<project path="system/netd" name="LineageOS/android_system_netd" groups="pdk" />-->
-  <project path="system/nfc" name="platform/system/nfc" groups="pdk" remote="aosp" />
+  <project path="system/nfc" name="LineageOS/android_system_nfc" groups="pdk" />
   <project path="system/nvram" name="platform/system/nvram" groups="pdk" remote="aosp" />
   <project path="system/secretkeeper" name="platform/system/secretkeeper" groups="pdk" remote="aosp" />
   <project path="system/security" name="LineageOS/android_system_security" groups="pdk" />
@@ -1250,7 +1250,7 @@
   <project path="system/server_configurable_flags" name="platform/system/server_configurable_flags" groups="pdk" remote="aosp" />
   <project path="system/teeui" name="platform/system/teeui" groups="pdk" remote="aosp" />
   <project path="system/testing/gtest_extras" name="platform/system/testing/gtest_extras" groups="pdk" remote="aosp" />
-  <project path="system/timezone" name="platform/system/timezone" groups="pdk" remote="aosp" />
+  <project path="system/timezone" name="LineageOS/android_system_timezone" groups="pdk" />
   <project path="system/tools/aidl" name="platform/system/tools/aidl" groups="pdk" remote="aosp" />
   <project path="system/tools/hidl" name="platform/system/tools/hidl" groups="pdk" remote="aosp" />
   <project path="system/tools/mkbootimg" name="LineageOS/android_system_tools_mkbootimg" groups="pdk" />
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
git -C .repo/manifests apply /tmp/manifest.patch
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
repo sync --force-sync external/expat
repo sync --force-sync packages/apps/KeyChain
repo sync --force-sync external/freetype
repo sync --force-sync external/libhevc
repo sync --force-sync packages/apps/TV
repo sync --force-sync system/incremental_delivery
repo sync --force-sync system/nfc

# Fix ADB Breakage post QPR1 by reverting to QPR1 tree
echo -e "\n=== packages/modules/adb ==="
repo sync --force-sync packages/modules/adb
cd packages/modules/adb
git fetch --unshallow losul
git checkout remotes/losul/lineage-21.0-qpr1
cd $BASEDIR
