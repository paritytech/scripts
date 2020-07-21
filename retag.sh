#!/bin/bash

# EXAMPLE USAGE: 
# ./retag.sh paritytech ci-linux staging production

set -eu

ORGA=$1
IMAGE=$2
TAG_OLD=$3
TAG_NEW=$4
echo "Organization: ${ORGA}"
echo "Image: ${IMAGE}"
echo "Old tag: ${TAG_OLD}"
echo "New tag: ${TAG_NEW}"

log_in() {
    read -p "Enter username: " UNAME
    REPONAME=${ORGA}/${IMAGE}

    if [ -n ${UNAME}  ]; then
        read -s -p "Password/token: " UPASS
        echo
    fi
}

get_token() {
    local HEADERS

    if [ -n "$UNAME"  ]; then
        HEADERS="Authorization: Basic $(echo -n "${UNAME}:${UPASS}" | base64)"
    fi
    echo "☑ Logging in"
    curl -s -H "$HEADERS" "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPONAME}:pull,push" | jq '.token' -r > token
    echo "☑ Got token"
}

pull_push_manifest() {
    local CONTENT_TYPE="application/vnd.docker.distribution.manifest.v2+json"
    local REGISTER_URI="https://registry-1.docker.io/v2"
    
    # read here https://docs.docker.com/registry/spec/auth/token/
    curl -s -H "Accept: ${CONTENT_TYPE}" -H "Authorization: Bearer $(cat token)" "${REGISTER_URI}/${REPONAME}/manifests/${TAG_OLD}" -o manifest.json
    echo "☑ Got manifest in manifest.json"
    curl -s -X PUT -H "Content-Type: ${CONTENT_TYPE}" -H "Authorization: Bearer $(cat token)" -d '@manifest.json' "${REGISTER_URI}/${REPONAME}/manifests/${TAG_NEW}"
    echo "☑ Pushed ${REPONAME}:${TAG_OLD} Manifest to ${REPONAME}:${TAG_NEW}"
}

clean_up() {
    rm token
    rm manifest.json
    echo "☑ Removed token and manifest.json files"
}

log_in
get_token ${REPONAME}
pull_push_manifest
clean_up
