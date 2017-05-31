#!/usr/bin/env bash


OWNER="rackerroush"
REPOSITORY="test1"
TOKEN=${GITHUB_PERSONAL_PUBLISH_TOKEN}

GIT_SUBJECT=$(git log --format=%s -n 1)

echo ${GIT_SUBJECT}

# Test for correct x.x.x semantic version from last git log entry
if [[ $GIT_SUBJECT =~ [0-9]+\.[0-9]+\.[0-9]+$ ]];
then
    VERSION=${BASH_REMATCH[0]};
    echo "INFO: Creating Release version: ${VERSION}"
else
    echo "
    Not able to parse version from last git log subject.
    Run this script after the update_version.sh script.
    "
    exit 0
fi


API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
#curl --data "$API_JSON" https://api.github.com/repos/:owner/:repository/releases?access_token=:access_token
curl -H "Authorization: token ${TOKEN}" --data "$API_JSON" https://api.github.com/repos/${OWNER}/${REPOSITORY}/releases
echo $API_JSON
