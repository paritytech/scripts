#!/bin/bash
# Copyright 2015-2018 Parity Technologies (UK) Ltd.

set -e  # Stop on all errors

## Update this with any new relase!
VERSION_STABLE="2.0.7"
VERSION_BETA="2.1.2"
##

RELEASE="beta"
ARCH=$(uname -m)
VANITY_SERVICE_URL="https://vanity-service.parity.io/parity-binaries?architecture=$ARCH&format=markdown"

check_os() {

	if [ "$(uname)" = "Linux" ] ; then
	PKG="linux"   # linux is my default 

	elif [ "$(uname)" = "Darwin" ] ; then
		PKG="darwin"
		echo "Running on Apple"
	else
		echo "Unknown operating system"
		echo "Please select your operating system"
		echo "Choices:"
		echo "	     linux - any linux distro"
		echo "	     darwin - MacOS"
		read PKG
	fi
}

get_package() {
	if [ "$RELEASE" = "beta" ]; then
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=v$VERSION_BETA"
	elif [ "$RELEASE" = "stable" ]; then
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=v$VERSION_STABLE"
	else
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=$RELEASE"
	fi

  MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | grep " \[parity\]")
  DOWNLOAD_FILE=$(echo $MD | grep -oE 'https://[^)]+')
}

check_upgrade() {

  # Determin new Version 
  case "$RELEASE" in
    "beta")  NEW_VERSION=$VERSION_BETA
        ;;
    "stable") NEW_VERSION=$VERSION_STABLE
        ;;
    *) NEW_VERSION=$(echo $DOWNLOAD_FILE | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | tr -d 'v')   
        ;;
  esac

  # Determin old (installed) Version 
  if [[ $(type -P "parity") ]] ; then
		OLD_VERSION=$(parity --version | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | tr -d 'v')
  else
		OLD_VERSION="0.0.0" # No version of Parity found.
	fi

	if [ "$NEW_VERSION" = "$OLD_VERSION" ] ; then
		echo "Parity $NEW_VERSION already installed"
		exit 1
	fi

  if  version_gt "$NEW_VERSION" "$OLD_VERSION"  ; then
		echo "Upgrading parity from $OLD_VERSION to $NEW_VERSION"
	else
		echo "Existing version of parity: $OLD_VERSION is newer than the version you attempting to install: $NEW_VERSION"
		exit 1
	fi
}

install() {
  TMPDIR=$(mktemp -d) && cd $TMPDIR
	curl -Ss -O $DOWNLOAD_FILE
  check_sha256

	if [ "$PKG" = "linux" ] ; then
	  sudo cp $TMPDIR/parity /usr/bin && sudo chmod +x /usr/bin/parity
	fi

	if [ "$PKG" = "darwin" ] ; then
	  sudo cp $TMPDIR/parity /usr/local/bin && sudo chmod +x /usr/local/bin/parity
	fi
}


version_gt() {
	test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}


help() {
	echo "Usage is: -r --release [ stable / beta / nightly ]"
}


check_sha256() {

  SHA256_CHECK=""
  for binary in rhash sha256sum shasum ; do
    echo "debug: check for $binary"
    [[ $(type -P ${binary}) ]] && SHA256_CHECK=${binary}
  done

  case ${SHA256_CHECK} in
    "rhash" )
      SHA256_CHECK="$SHA256_CHECK --sha256"
      #echo "debug: rhash"
      ;;
    "sha256sum" )
      #echo "debug: sha256sum"
      ;;
    "shasum" )
      SHA256_CHECK="shasum -a 256"
      # echo "debug: shasum"
      ;;
    * )
      echo "Unable to check SHA256 checksum, please install sha256sum or rhash binary"
      cleanup
      exit 1
      ;;
  esac

  # $SHA256_CHECK $TMPDIR/$DOWNLOAD_FILE 
  IS_CHECKSUM=$($SHA256_CHECK $TMPDIR/parity | awk '{print $1}')
  MUST_CHECKSUM=$(curl -sS $LOOKUP_URL | grep ' \[parity\]' | awk '{print $NF'})
  if [[ $IS_CHECKSUM != $MUST_CHECKSUM ]]; then
    echo "SHA256 Checksum missmatch, aboarding installation"
    cleanup
    exit 1 
  fi
}

cleanup() {
  rm $TMPDIR/*
  rmdir $TMPDIR
}

## MAIN ##

# is curl?
[[ $(type -P "curl") ]] || { echo '"curl" binary not found, please install and retry' 1>&2; exit 1; }

while [ "$1" != "" ]; do
	case $1 in
	-r | --release )           shift
		RELEASE=$1
		;;
	* )  	help
		exit 1
		esac
	shift
	done

	echo "Release selected is: $RELEASE"

check_os
get_package
if [ "$RELEASE" != "nightly" ] ; then
	check_upgrade
fi
install
cleanup
