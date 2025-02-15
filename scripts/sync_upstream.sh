#!/bin/bash

set -eo pipefail

git diff-index --quiet HEAD --
if [ $? -ne 0 ]; then
    echo "Do not run this script on a dirty tree!"
    exit 1
fi

upstream_tag=$1

pushd ../core

git fetch upstream
git checkout $upstream_tag

popd

git checkout -b $upstream_tag

rsync -rav ../core/homeassistant/components/openai_conversation/ custom_components/flexible_openai_conversation/

git add custom_components/flexible_openai_conversation

git commit -m "snapshot $upstream_tag"
