#!/bin/sh
sudo apt install git
# To debug SELinux (audit2allow tool)
sudo apt install policycoreutils-python-utils

git clone https://github.com/metterschlg/scripts
# Setup build environment
cd scripts
./build_environment.sh
# Initialize LineageOS 20 environment
# As this will also download the sources it can take hours - depending on line speed
./lineage-20.sh

# This is required for Ubuntu 22.04
sudo ln -s /usr/bin/python3 /usr/bin/python

# Setup build configuration
cd ~/android/lineage-20.0/
source build/envsetup.sh

# Setup local manifest
cd .repo
git clone -b lineage-20 https://github.com/metterschlg/local_manifests
cd local_manifests/
# Just keep the manifest we need to build for gts28ltexx
rm gts210ltexx.xml gts210wifi.xml gts28wifi.xml tbelteskt.xml tre3calteskt.xml trelteskt.xml treltexx.xml trhpltexx.xml

# Pull the latest sources - can take hours depending on network connection
croot
repo sync

# for samsung_slsi libfimg4x: Fix a -Wunreachable-code-loop-increment compilation error
repopick -f 331661

# Patch to fix OS crash to MPPthread.
curl -o ~/remove-MPPThread.patch https://raw.githubusercontent.com/retiredtab/LineageOS-build-manifests/main/20/exynos5433/remove-MPPThread.patch
cd hardware/samsung_slsi/exynos
patch -p1 < ~/remove-MPPThread.patch
croot

# Select SM-T715 for the build
breakfast gts28ltexx
# Start build - this might take many hours for the initial build
time brunch gts28ltexx
# To create engineering builds, alternatively use
# TARGET_BUILD_TYPE=debug TARGET_BUILD_VARIANT=eng m bacon

# Display the generated ROM file(s)
ls -alh out/target/product/gts28ltexx/lineage-20.0-*-UNOFFICIAL-gts28ltexx.zip
