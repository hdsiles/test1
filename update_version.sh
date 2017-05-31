#!/usr/bin/env bash

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







CHG_LOG=$(git log --no-merges --format=%s | awk '/^Set version to '${VERSION}'$/{flag=1;next}/^Set version to [0-9]+\.[0-9]+\.[0-9]+$/{flag=0}flag')
#CHG_LOG=$(git log --no-merges --format=%s | sed -e '/^Set version to '${VERSION}'$/{flag=1;next}/^Set version to [0-9]+\.[0-9]+\.[0-9]+$/{flag=0}flag')


git checkout -b ${VERSION}
echo $VERSION > version
git add update_version.sh
git add version
git commit -m "Set version to $VERSION"
#git push origin
git push --set-upstream origin ${VERSION}

#API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
API_JSON=$(printf '{"title": "%s", "body": "%s", "head": "%s:%s", "base": "master"}' $VERSION $CHG_LOG $REPOSITORY $VERSION)
curl -H "Authorization: token ${TOKEN}" --data "$API_JSON" https://api.github.com/repos/${OWNER}/${REPOSITORY}/pulls
