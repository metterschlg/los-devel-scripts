#!/bin/sh
# October-December 2024 Android & LineageOS security patches

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

# October-December 2024 & January 2025
merge_upstream frameworks/base

# October 2024
merge_upstream system/core

# October 2024 & November 2024
merge_upstream device/lineage/sepolicy
cd device/lineage/sepolicy
git add common/vendor/file_contexts
git merge --continue
cd $BASEDIR

# October-November 2024 & January 2025
merge_upstream vendor/lineage
cd vendor/lineage
cat <<EOF>>/tmp/vendor_lineage_build_soong_Android_bp.patch
diff --git a/build/soong/Android.bp b/build/soong/Android.bp
index 1e2832d9..f8bf4429 100644
--- a/build/soong/Android.bp
+++ b/build/soong/Android.bp
@@ -642,6 +642,7 @@ stagefright_qcom_legacy {
         uses_qcom_bsp_legacy: {
             cppflags: ["-DQCOM_BSP_LEGACY"],
         },
+    }
 }
 
 soong_config_module_type {
EOF
git apply /tmp/vendor_lineage_build_soong_Android_bp.patch
git add build/soong/Android.bp
git merge --continue
rm /tmp/vendor_lineage_build_soong_Android_bp.patch
cd $BASEDIR

# October 2024
merge_upstream packages/modules/Bluetooth

# November 2024
merge_upstream system/netd

# November 2024
merge_upstream packages/modules/Connectivity

# November-December 2024
merge_upstream frameworks/native

# January 2025
REMOTE=$(git -C hardware/qcom-caf/common remote -v | grep -v upstream | head -1 | awk {'print $1'})
if [ $REMOTE = "github" ]; then
    git -C hardware/qcom-caf/common remote rename github losul
fi
merge_upstream hardware/qcom-caf/common

# January 2025
merge_upstream packages/services/Telephony

# Fix ADB Breakage post QPR1 by reverting to QPR1 tree
echo -e "\n=== packages/modules/adb ==="
repo sync --force-sync packages/modules/adb
cd packages/modules/adb
git fetch --unshallow losul
git checkout remotes/losul/lineage-21.0-qpr1
cd $BASEDIR
