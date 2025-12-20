#!/bin/sh
# December 2025 Android & LineageOS security patches

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

# April & May & June 2025 & August 2025 & September 2025 & December 2025
merge_upstream frameworks/base
# April & May & June 2025 & September 2025 & November 2025 & December 2025
merge_upstream packages/modules/Bluetooth
# May 2025 & September 2025
merge_upstream packages/modules/Wifi
# June 2025 & September 2025
merge_upstream frameworks/av
# June 2025
merge_upstream packages/modules/Connectivity
# September 2025
merge_upstream packages/apps/Nfc
# September 2025 & December 2025
merge_upstream frameworks/opt/telephony
# September 2025 & December 2025
merge_upstream frameworks/native

# April & May & June & September & December 2025 own fork tracking
cat <<EOF>/tmp/android-fork-tracking.patch
diff --git a/default.xml b/default.xml
index 7dfed8f..10fa254 100644
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
@@ -285,7 +285,7 @@
   <project path="external/libgsm" name="platform/external/libgsm" groups="pdk" remote="aosp" />
   <project path="external/libhevc" name="platform/external/libhevc" groups="pdk" remote="aosp" />
   <project path="external/libiio" name="platform/external/libiio" groups="pdk" remote="aosp" />
-  <project path="external/libjpeg-turbo" name="platform/external/libjpeg-turbo" groups="pdk" remote="aosp" />
+  <project path="external/libjpeg-turbo" name="LineageOS/android_external_libjpeg-turbo" groups="pdk" />
   <project path="external/libkmsxx" name="platform/external/libkmsxx" groups="pdk" remote="aosp" />
   <project path="external/libldac" name="platform/external/libldac" groups="pdk" remote="aosp" />
   <project path="external/libmpeg2" name="platform/external/libmpeg2" groups="pdk" remote="aosp" />
@@ -667,7 +667,7 @@
   <project path="external/sonic" name="platform/external/sonic" groups="pdk" remote="aosp" />
   <project path="external/sonivox" name="LineageOS/android_external_sonivox" groups="pdk" />
   <project path="external/speex" name="platform/external/speex" groups="pdk" remote="aosp" />
-  <project path="external/sqlite" name="platform/external/sqlite" groups="pdk" remote="aosp" />
+  <project path="external/sqlite" name="LineageOS/android_external_sqlite" groups="pdk" />
   <project path="external/squashfs-tools" name="platform/external/squashfs-tools" groups="pdk" remote="aosp" />
   <project path="external/stardoc" name="platform/external/stardoc" groups="pdk" remote="aosp" />
   <project path="external/starlark-go" name="platform/external/starlark-go" groups="pdk" remote="aosp" />
@@ -870,7 +870,7 @@
   <project path="packages/apps/Car/SystemUpdater" name="platform/packages/apps/Car/SystemUpdater" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/CarrierConfig" name="platform/packages/apps/CarrierConfig" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
   <project path="packages/apps/CellBroadcastReceiver" name="LineageOS/android_packages_apps_CellBroadcastReceiver" groups="pdk-cw-fs,pdk-fs" />
-  <project path="packages/apps/CertInstaller" name="platform/packages/apps/CertInstaller" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
+  <project path="packages/apps/CertInstaller" name="LineageOS/android_packages_apps_CertInstaller" groups="pdk-cw-fs,pdk-fs" />
   <project path="packages/apps/Contacts" name="LineageOS/android_packages_apps_Contacts" groups="pdk-fs" />
   <project path="packages/apps/Dialer" name="LineageOS/android_packages_apps_Dialer" groups="pdk-fs" />
   <project path="packages/apps/DocumentsUI" name="LineageOS/android_packages_apps_DocumentsUI" groups="pdk-cw-fs,pdk-fs" />
@@ -878,7 +878,7 @@
   <project path="packages/apps/HTMLViewer" name="platform/packages/apps/HTMLViewer" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/ImsServiceEntitlement" name="platform/packages/apps/ImsServiceEntitlement" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/KeyChain" name="LineageOS/android_packages_apps_KeyChain" groups="pdk-fs" />
-  <project path="packages/apps/ManagedProvisioning" name="platform/packages/apps/ManagedProvisioning" groups="pdk-fs" remote="aosp" />
+  <project path="packages/apps/ManagedProvisioning" name="LineageOS/android_packages_apps_ManagedProvisioning" groups="pdk-fs" />
   <project path="packages/apps/Messaging" name="LineageOS/android_packages_apps_Messaging" groups="pdk-fs" />
   <project path="packages/apps/Music" name="platform/packages/apps/Music" groups="pdk-fs" remote="aosp" />
   <project path="packages/apps/MusicFX" name="platform/packages/apps/MusicFX" groups="pdk-fs" remote="aosp" />
@@ -919,14 +919,14 @@
   <project path="packages/modules/BootPrebuilt/5.4/arm64" name="platform/packages/modules/BootPrebuilt/5.4/arm64" groups="pdk" clone-depth="1" remote="aosp" />
   <project path="packages/modules/BootPrebuilt/5.10/arm64" name="platform/packages/modules/BootPrebuilt/5.10/arm64" groups="pdk" clone-depth="1" remote="aosp" />
   <project path="packages/modules/CaptivePortalLogin" name="platform/packages/modules/CaptivePortalLogin" groups="pdk-cw-fs,pdk-fs" remote="aosp" />
-  <project path="packages/modules/CellBroadcastService" name="platform/packages/modules/CellBroadcastService" groups="pdk" remote="aosp" />
+  <project path="packages/modules/CellBroadcastService" name="LineageOS/android_packages_modules_CellBroadcastService" groups="pdk" />
   <project path="packages/modules/common" name="LineageOS/android_packages_modules_common" groups="pdk-cw-fs,pdk-fs" />
   <!--<project path="packages/modules/Connectivity" name="LineageOS/android_packages_modules_Connectivity" groups="pdk-cw-fs,pdk-fs" />-->
   <project path="packages/modules/DnsResolver" name="LineageOS/android_packages_modules_DnsResolver" groups="pdk-cw-fs,pdk-fs" />
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
repo sync --force-sync external/libjpeg-turbo
repo sync --force-sync external/sqlite
repo sync --force-sync packages/apps/CellBroadcastReceiver
repo sync --force-sync packages/apps/CertInstaller
repo sync --force-sync packages/apps/ManagedProvisioning
repo sync --force-sync packages/modules/CellBroadcastService
repo sync --force-sync packages/modules/IntentResolver
