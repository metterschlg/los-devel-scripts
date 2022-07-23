#!/bin/sh
sudo apt install git
# To debug SELinux (audit2allow tool)
sudo apt install policycoreutils-python-utils

# Create patch to adjust ripee's build environment script
echo "Patching ripee's build environment script: "
echo "  1. Use apt instead of deprecated apt-get"
echo "  2. Limit compiler cache to 50GB instead of 100GB"
echo "  3. Clone using https instead of git to not require a github account"
cat <<EOF > ~/ripee-script.patch
diff --git a/build_environment.sh b/build_environment.sh
index e1c9b0c..2cb75f1 100755
--- a/build_environment.sh
+++ b/build_environment.sh
@@ -1,15 +1,15 @@
 #!/bin/bash
 
-sudo apt-get -y update
-sudo apt-get -y upgrade
-sudo apt-get -y dist-upgrade
-sudo apt-get -y remove openjdk-* icedtea-* icedtea6-*
-sudo apt-get -y install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop openjdk-8-jdk pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
+sudo apt -y update
+sudo apt -y upgrade
+sudo apt -y dist-upgrade
+sudo apt -y remove openjdk-* icedtea-* icedtea6-*
+sudo apt -y install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop openjdk-8-jdk pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
 sudo apt -y autoremove
 mkdir ~/bin
 curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
 chmod a+x ~/bin/repo
-ccache -M 100G
+ccache -M 50G
 echo 'export ANDROID_COMPILE_WITH_JACK=false' >> ~/.bashrc
 echo 'export CCACHE_EXEC=/usr/bin/ccache' >> ~/.bashrc
 echo 'export LANG=C' >> ~/.bashrc
diff --git a/lineage-18.1.sh b/lineage-18.1.sh
index 54add2f..8d4fff5 100755
--- a/lineage-18.1.sh
+++ b/lineage-18.1.sh
@@ -2,7 +2,7 @@
 
 mkdir -p ~/android/lineage-18.1
 cd ~/android/lineage-18.1
-repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1
+repo init --depth=1 -u https://github.com/LineageOS/android.git -b lineage-18.1
 repo sync -c --force-sync --no-clone-bundle --no-tags
 mkdir -p .repo/local_manifests
 cd
EOF
git clone https://github.com/ripee/scripts
cd scripts/
patch < ~/ripee-script.patch

# Setup build environment
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
