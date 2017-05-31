#!/usr/bin/env bash

VERSION=$1

OWNER="rackerroush"
REPOSITORY="test1"
TOKEN=${GITHUB_PERSONAL_PUBLISH_TOKEN}

API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "master","name": "v%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
#curl --data "$API_JSON" https://api.github.com/repos/:owner/:repository/releases?access_token=:access_token
curl -H "Authorization: token ${TOKEN}" --data "$API_JSON" https://api.github.com/repos/${OWNER}/${REPOSITORY}/releases
echo $API_JSON
