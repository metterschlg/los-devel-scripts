#!/bin/sh
# File sizes:
#2664692 libsec-ril_previous.so
#3083940 libsec-ril.so_git-head
#3083940 libsec-ril.so_patchelf_0.10_ubuntu_default
#3244208 libsec-ril.so_patchelf-0.14.5
#3133412 libsec-ril.so_patchelf-0.9
echo "Downloading and building patchelf 0.9..."
wget https://github.com/NixOS/patchelf/archive/refs/tags/0.9.zip -O patchelf-0.9.zip
unzip patchelf-0.9.zip
cd patchelf-0.9
./bootstrap.sh && ./configure && make
cd ..
echo "Retrieve last working libsec-ril.so instance..."
wget https://github.com/universal5433/proprietary_vendor_samsung/raw/b510a8c5b72d698beaa10b520e2255bd18872ae2/gts28ltexx/proprietary/system/lib/libsec-ril.so
echo "Patching libsec-ril.so using patchelf-0.9..."
patchelf-0.9/src/patchelf --replace-needed libcutils.so libcutils-v29.so libsec-ril.so
