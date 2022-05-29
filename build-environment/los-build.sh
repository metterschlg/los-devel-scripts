#!/bin/sh
sudo apt install git
# To debug SELinux (audit2allow tool)
sudo apt install policycoreutils-python-utils
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
./build_environment.sh 
./lineage-18.1.sh 
sudo ln -s /usr/bin/python3 /usr/bin/python
cd ~/android/lineage-18.1/.repo
git clone https://github.com/universal5433/local_manifests -b lineage-18.1
cd local_manifests/
# Just keep the manifest we need to build for gts28ltexx
rm gts210ltexx.xml gts210wifi.xml gts28wifi.xml tbelteskt.xml tre3calteskt.xml trelteskt.xml treltexx.xml trhpltexx.xml
cd ../..
source build/envsetup.sh 
repo sync
breakfast gts28ltexx
# see https://github.com/metterschlg/los-devel-scripts/blob/main/blob-patching/patch_libsec-ril.sh
# for instructions how to create the patched libsec-ril.so
cp ~/libsec-ril.so ~/android/lineage-18.1/samsung/gts28ltexx/proprietary/system/lib/libsec-ril.so
cp ~/libsec-ril.so ~/android/lineage-18.1/samsung/gts28ltexx/proprietary/system/vendor/lib/libsec-ril.so
brunch gts28ltexx
ls -alh out/target/product/gts28ltexx/lineage-18.1-*-UNOFFICIAL-gts28ltexx.zip
