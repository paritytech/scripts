#!/bin/bash
# Copyright 2017 Parity Technologies (UK) Ltd.
BUILD="beta"
ARCH=$(uname -m)
VANITY_SERVICE_URL="https://vanity-service.ethcore.io/parity-binaries?architecture=$ARCH&format=markdown"

check_os() {

	if [ "$(uname)" = "Linux" ] ; then

	if [ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]; then
		PKG="debian"
	else
		PKG="linux"
	fi

	elif [ "$(uname)" = "Darwin" ] ; then
		PKG="darwin"
		echo "Running on Apple"
	else
		echo "Unknown operating system"
		echo "Please select your operating system"
		echo "Choices: debian - Ubuntu / Debian"
		echo "	     linux - Other linux distro"
		echo "	     darwin - MacOS"
		read PKG
	fi
}

get_package() {

	LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=$BUILD"

	if [ "$PKG" = "debian" ] ; then
		MD=$(curl ${LOOKUP_URL} | grep amd64 )
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "linux" ] ; then
		MD=$(curl ${LOOKUP_URL} | grep "\[parity\]")
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "darwin" ] ; then
		MD=$(curl ${LOOKUP_URL} | grep pkg )
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi
	echo "Download file: $DOWNLOAD_FILE"
}

check_upgrade() {

        TMPDIR=$(mktemp -d)
        cd $TMPDIR
        $(wget $DOWNLOAD_FILE)

	if [ -f /usr/bin/parity ] ; then
		OLD_VERSION=$(parity --version | grep version|  cut -d/ -f2  | cut -d- -f1 | sed 's/v//g')
	else
		echo "No older version of parity found"
		OLD_VERSION="0.0.0"
	fi

	if [ "$PKG" = "linux" ] ; then
		NEW_VERSION=$($TMPDIR/parity --version  | grep version|  cut -d/ -f2  | cut -d- -f1 | sed 's/v//g')

	fi

	if [ "$PKG" = "debian" ] ; then
		NEW_VERSION=$(basename $DOWNLOAD_FILE  |  cut -d_ -f2)
	fi

	if [ "$PKG" = "darwin" ] ; then
		NEW_VERSION=$(basename $DOWNLOAD_FILE | cut -d- -f2)
	fi


	if  version_gt "$NEW_VERSION" "$OLD_VERSION"  ; then
		echo "Upgrading parity from $OLD_VERSION to $NEW_VERSION"
	else
		echo "Old version of parity: $OLD_VERSION is newer than the version you attempting to install: $NEW_VERSION"
		exit 1
	fi
}


install() {

	if [ "$PKG" = "debian" ] ; then
		NAME=$(basename $DOWNLOAD_FILE)
		sudo dpkg -i $TMPDIR/$NAME
	fi

	if [ "$PKG" = "linux" ] ; then
		sudo cp $TMPDIR/parity /usr/bin
		sudo chmod +x /usr/bin/parity
	fi

	if [ "$PKG" = "darwin" ] ; then
		NAME=$(basename $DOWNLOAD_FILE)
		sudo /usr/sbin/installer -pkg $TMPDIR/$NAME -target /
	fi

}


version_gt() {
	test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}


help() {

	echo "Usage is: -b --build [ stable / beta / nightly ]"

}


while [ "$1" != "" ]; do
	case $1 in
	-b | --build )           shift
		BUILD=$1
		;;
	* )  	help
		exit 1
		esac
	shift
	done


	echo "Build selected is: $BUILD"

check_os
get_package
check_upgrade
install
