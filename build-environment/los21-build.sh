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

# Pull the latest sources - can take hours depending on network connection
croot
repo sync

# Since September 2024 the LineageOS-UL trees are no longer synced with upstream security patches -> perform manually
source los21ul-fixes.sh

# Various hardware platform patches
curl -o ~/hardware_samsung.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/20/exynos5433/hardware_samsung.diff
cd hardware/samsung/
patch -p1 < ~/hardware_samsung.diff
croot
curl -o ~/hardware_samsung_slsi_exynos.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/20/exynos5433/hardware_samsung_slsi_exynos.diff
cd hardware/samsung_slsi/exynos/
patch -p1 < ~/hardware_samsung_slsi_exynos.diff
croot
curl -o ~/hardware_samsung_slsi_exynos5433.diff https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/20/exynos5433/hardware_samsung_slsi_exynos5433.diff
cd hardware/samsung_slsi/exynos5433
patch -p1 < ~/Downloads/5433-patches/hardware_samsung_slsi_exynos5433.diff
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
