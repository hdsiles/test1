#!/usr/bin/env bash

set -e

VERSION=$1
REPOSITORY='test1'
OWNER='rackerroush'
TOKEN=${GITHUB_PERSONAL_PUBLISH_TOKEN}

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

git checkout -b ${VERSION}
echo $VERSION > version
git add update_version.sh
git add version
git commit -m "Set version to $VERSION"
git push --set-upstream origin ${VERSION}

API_JSON=$(printf '{"title": "%s", "body": "%s", "head": "Version changes to file for %s", "base": "master"}' $VERSION $VERSION $VERSION)
echo $API_JSON
curl -H "Authorization: token ${TOKEN}" -X POST --data "$API_JSON" https://api.github.com/repos/${OWNER}/${REPOSITORY}/pulls
