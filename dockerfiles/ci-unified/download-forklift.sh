#!/bin/bash

DL_PATH="$HOME/.forklift4"
VERSION="latest"

while getopts "p:v:" flag; do
  case $flag in
    v) # version
    VERSION=$OPTARG
    ;;
    p) # download path
    DL_PATH=$OPTARG
    ;;
    \?)
    echo "invalid option '$flag'"
    exit 1
    ;;
  esac
done

RELEASE_URL="https://api.github.com/repos/paritytech/forklift/releases/tags/$VERSION"

if [[ "latest" == $VERSION ]]; then
  RELEASE_URL="https://api.github.com/repos/paritytech/forklift/releases/latest"
fi

echo "Downloading forklift $VERSION to $DL_PATH from $RELEASE_URL"

RELEASE=`curl -s $RELEASE_URL`
ASSET=`jq '.assets[] | select(.name | endswith("linux_amd64"))' <<< "$RELEASE"`

ASSET_NAME=`jq -r '.name' <<< "$ASSET"`
ASSET_URL=`jq -r '.browser_download_url' <<< "$ASSET"`

mkdir -p $DL_PATH
curl -L -s -o $DL_PATH/$ASSET_NAME -L $ASSET_URL
cp -r $DL_PATH/$ASSET_NAME /usr/local/bin/forklift

chmod 755 /usr/local/bin/forklift
