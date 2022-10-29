#!/bin/sh
sudo apt install git
# To debug SELinux (audit2allow tool)
sudo apt install policycoreutils-python-utils

git clone https://github.com/metterschlg/scripts
# Setup build environment
cd scripts
./build_environment.sh
# Initialize LineageOS 18.1 environment
# As this will also download the sources it can take hours - depending on line speed
./lineage-18.1.sh

# This is required for Ubuntu 22.04
sudo ln -s /usr/bin/python3 /usr/bin/python

# Setup build configuration
cd ~/android/lineage-18.1/
source build/envsetup.sh

# Setup local manifest
cd .repo
git clone -b lineage-18.1 https://github.com/metterschlg/local_manifests
cd local_manifests/
# Just keep the manifest we need to build for gts28ltexx
rm gts210ltexx.xml gts210wifi.xml gts28wifi.xml tbelteskt.xml tre3calteskt.xml trelteskt.xml treltexx.xml trhpltexx.xml

# Apply the patch at: https://github.com/DerpFest-11/packages_modules_NetworkStack/commit/22fd53a977eeaf4e36be7bf6358ecf2c2737fa5e
# It's required to prevent tcp/ip error messages that are flooding the logcat.
cd ~
git clone https://github.com/DerpFest-11/packages_modules_NetworkStack
cd packages_modules_NetworkStack/
git show 22fd53a977eeaf4e36be7bf6358ecf2c2737fa5e  > ~/TcpSocketTracker_optout.patch
cd ~/android/lineage-18.1/packages/modules/NetworkStack
git apply ~/TcpSocketTracker_optout.patch

# Pull the latest sources - can take hours depending on network connection
croot
repo sync
# Select SM-T715 for the build
breakfast gts28ltexx
# Start build - this might take many hours for the initial build
time brunch gts28ltexx
# To create engineering builds, alternatively use
# TARGET_BUILD_TYPE=debug TARGET_BUILD_VARIANT=eng m bacon

# Display the generated ROM file(s)
ls -alh out/target/product/gts28ltexx/lineage-18.1-*-UNOFFICIAL-gts28ltexx.zip
