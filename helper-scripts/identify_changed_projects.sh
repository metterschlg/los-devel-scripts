#!/bin/sh
echo "================================ Changed LineageOS-$1 repos after $2 ================================"
CHANGED_PROJECTS=$(curl -s https://review.lineageos.org/changes/?q=status:merged+branch:lineage-$1+after:$2 | tail -1 | jq '.[].project' | sort | uniq | sed -e 's/LineageOS\/android.//' | sed -e 's/\"//g')
REMOTES=""
for PROJECT in $CHANGED_PROJECTS; do
    echo "-- $PROJECT --"
    if [ "$PROJECT" = "packages_apps_ElmyraService" ]; then
	echo "ElmyraService is not observed (Pixel devices only)"
	continue;
    fi
    PROJECT_PATH=$(grep -r ${PROJECT}\" .repo/manifests | grep -v "<\!--.*--" | awk '{print $3}' | sed -e 's/path=//' | sed -e 's/"//g')
    REMOTE=$(git -C $PROJECT_PATH remote -v |sed -e 's/(fetch)\|(push)//' | uniq)
    echo $REMOTE
    REMOTES="$REMOTES\n$REMOTE"
done
echo "================================== Changed LOS-UL or AOSP projects =================================="
echo $REMOTES | grep "losul\|aosp" | sort
