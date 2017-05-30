#!/usr/bin/env bash

VER=$1
echo "Updating to version $VER"
echo $VER > version
git add update_version.sh
git add version
git commit -m "Set version to $VER"
git push origin

