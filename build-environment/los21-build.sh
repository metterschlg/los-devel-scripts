#!/bin/sh
sudo apt install git
# To debug SELinux (audit2allow tool)
sudo apt install policycoreutils-python-utils

git clone https://github.com/metterschlg/scripts
# Setup build environment
cd scripts
./build_environment.sh
# Initialize LineageOS 21 environment
# As this will also download the sources it can take hours - depending on line speed
./lineage-21.sh

# This is required for Ubuntu 22.04
sudo ln -s /usr/bin/python3 /usr/bin/python

# Setup build configuration
cd ~/android/lineage-21.0/
source build/envsetup.sh

# Setup local manifest
cd .repo
git clone -b lineage-21 https://github.com/metterschlg/local_manifests
cd local_manifests/
# Just keep the manifest we need to build for gts28ltexx
rm gts210ltexx.xml gts210wifi.xml gts28wifi.xml tbelteskt.xml tre3calteskt.xml trelteskt.xml treltexx.xml trhpltexx.xml

croot
# Since September 2024 the LineageOS-UL trees are no longer synced with upstream tracked repos -> perform manually
cat <<EOF>/tmp/manifest.patch
diff --git a/default.xml b/default.xml
index 19c3190..e37eca0 100644
--- a/default.xml
+++ b/default.xml
@@ -141,7 +141,7 @@
   <project path="external/compiler-rt" name="platform/external/compiler-rt" groups="pdk" remote="aosp" />
   <project path="external/ComputeLibrary" name="platform/external/ComputeLibrary" groups="pdk-lassen,pdk-gs-arm" remote="aosp" />
   <project path="external/connectedappssdk" name="platform/external/connectedappssdk" groups="pdk" remote="aosp" />
-  <project path="external/conscrypt" name="platform/external/conscrypt" groups="pdk" remote="aosp" />
+  <project path="external/conscrypt" name="LineageOS/android_external_conscrypt" groups="pdk" />
   <project path="external/cpu_features" name="platform/external/cpu_features" groups="pdk" remote="aosp" />
   <project path="external/cpuinfo" name="platform/external/cpuinfo" groups="pdk" remote="aosp" />
   <project path="external/crcalc" name="platform/external/crcalc" groups="pdk" remote="aosp" />
@@ -197,7 +197,7 @@
   <project path="external/geojson-jackson" name="platform/external/geojson-jackson" groups="pdk" remote="aosp" />
   <project path="external/geonames" name="platform/external/geonames" groups="pdk" remote="aosp" />
   <project path="external/gflags" name="platform/external/gflags" groups="pdk" remote="aosp" />
-  <project path="external/giflib" name="platform/external/giflib" groups="pdk,qcom_msm8x26" remote="aosp" />
+  <project path="external/giflib" name="LineageOS/android_external_giflib" groups="pdk,qcom_msm8x26" />
   <project path="external/glide" name="platform/external/glide" groups="pdk" remote="aosp" />
   <project path="external/go-cmp" name="platform/external/go-cmp" groups="pdk" remote="aosp" />
   <project path="external/golang-protobuf" name="platform/external/golang-protobuf" groups="pdk" remote="aosp" />
EOF
cd .repo/manifests
git apply /tmp/manifest.patch
croot
# Pull the latest sources
repo sync --force-sync

# Since September 2024 the LineageOS-UL trees are no longer synced with upstream security patches -> perform manually
source los21ul-fixes.sh

# Various hardware platform patches
curl -o /tmp/hardware_samsung.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/21/exynos5433/hardware_samsung.diff
cd hardware/samsung/
patch -p1 < /tmp/hardware_samsung.diff
croot
curl -o /tmp/hardware_samsung_slsi_exynos.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/21/exynos5433/hardware_samsung_slsi_exynos.diff
cd hardware/samsung_slsi/exynos/
patch -p1 < /tmp/hardware_samsung_slsi_exynos.diff
croot
curl -o /tmp/hardware_samsung_slsi_exynos5433.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/21/exynos5433/hardware_samsung_slsi_exynos5433.diff
cd hardware/samsung_slsi/exynos5433
patch -p1 < /tmp/hardware_samsung_slsi_exynos5433.diff
croot
curl -o /tmp/hardware_lineage_interfaces.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/21/UL-patches-2024/hardware_lineage_interfaces.diff
cd hardware/lineage/interfaces
patch -p1 < /tmp/hardware_lineage_interfaces.diff
croot

# for samsung_slsi libfimg4x: Fix a -Wunreachable-code-loop-increment compilation error
repopick -f 331661

# Select SM-T715 for the build
breakfast gts28ltexx
# Start build - this might take many hours for the initial build
time brunch gts28ltexx
# To create engineering builds, alternatively use
# TARGET_BUILD_TYPE=debug TARGET_BUILD_VARIANT=eng m bacon

# Display the generated ROM file(s)
ls -alh out/target/product/gts28ltexx/lineage-21.0-*-UNOFFICIAL-gts28ltexx.zip
