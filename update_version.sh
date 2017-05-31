#!/usr/bin/env bash

VERSION=$1

# Test for correct x.x.x semantic version for input
if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]];
then
    VERSION=${BASH_REMATCH[0]};
    echo "INFO: Setting to version ${VERSION}"
else
    echo "
    Not able to parse version from input.
    Usage example: ${BASH_SOURCE[0]} 0.1.2
    "
    exit 0
fi

echo $VERSION > version
git add update_version.sh
git add version
git commit -m "Set version to $VERSION"
#git push origin
git push --set-upstream origin ${VERSION}
