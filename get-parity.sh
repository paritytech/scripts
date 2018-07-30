#!/bin/bash
# Copyright 2017 Parity Technologies (UK) Ltd.

## Update this with any new relase!
VERSION_STABLE="1.11.8"
VERSION_BETA="2.0.1"
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
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=beta-release"
	elif [ "$RELEASE" = "stable" ]; then
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=stable-release"
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
  parity_bin=$(which parity)

	if [ -z $parity_bin ] ; then
		OLD_VERSION="0.0.0"
	else
		OLD_VERSION=$(parity --version | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | tr -d 'v')
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
  # how to check for sha256?
  SHA256_CHECK=$(which sha256sum 2> /dev/null)
  if [[ -z $SHA256_CHECK ]] ; then
    # no sha256sum? try with rhash ...
    SHA256_CHECK=$(which rhash 2> /dev/null)
    SHA256_CHECK="$SHA256_CHECK --sha256"
  fi

  if [ "$PKG" = "darwin" ] ; then
    SHA256_CHECK="shasum -a 256"
  fi

  # see if we can call the binary to calculate sha256 sums
  if ! ($SHA256_CHECK --version &> /dev/null) then
    echo "Unable to check SHA256 checksum, please install sha256sum or rhash binary"
    cleanup
    exit 1
  fi

  # $SHA256_CHECK $TMPDIR/$DOWNLOAD_FILE 
  IS_CHECKSUM=$($SHA256_CHECK $TMPDIR/parity | awk '{print $1}')
  MUST_CHECKSUM=$(curl -sS $LOOKUP_URL | grep ' \[parity\]' | awk '{print $NF'})
  # debug # echo -e "is checksum:\t $IS_CHECKSUM"
  # debug # echo -e "must checksum:\t $MUST_CHECKSUM"
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

## curl installed? 
which curl &> /dev/null 
if [[ $? -ne 0 ]] ; then
    echo '"curl" binary not found, please install and retry'
    exit 1
fi
##

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
