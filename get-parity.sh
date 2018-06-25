#!/bin/bash
# Copyright 2017 Parity Technologies (UK) Ltd.
RELEASE="beta"
ARCH=$(uname -m)
VANITY_SERVICE_URL="https://vanity-service.parity.io/parity-binaries?architecture=$ARCH&format=markdown"
LIBSSL="undef"

check_os() {

	if [ "$(uname)" = "Linux" ] ; then
	PKG=linux   # linux is my default 

	if  (cat /proc/version | grep -Piq '(debian|ubuntu)')  ; then
	  LIBSSL=10
      grep -qi 'stretch' /etc/*release && PKG=debian 
	fi

	cat /proc/version | grep -iPq '(redhat|centos)' && PKG=centos 

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
	if [ "$RELEASE" = "beta" ]; then
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=beta-release"
	elif [ "$RELEASE" = "stable" ]; then
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=stable-release"
	else
		LOOKUP_URL="$VANITY_SERVICE_URL&os=$PKG&version=$RELEASE"
	fi

	if [ "$PKG" = "debian" ] ; then
        MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | grep -v md5 | grep amd64 | grep deb )
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "linux" -a "$LIBSSL" = "10" ]; then
        MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | | grep -v md5 | grep deb)
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "linux" -a "$LIBSSL" = "undef" ]; then
	MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | grep -v md5 | grep "\[parity\]")
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "centos" ] ; then
        MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | grep -v md5 | grep "rpm")
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi

	if [ "$PKG" = "darwin" ] ; then
		MD=$(curl -Ss ${LOOKUP_URL} | grep -v sha256 | grep -v md5 | grep pkg )
		DOWNLOAD_FILE=$(echo $MD | cut -d "(" -f2 | cut -d ")" -f1)
	fi
}

check_upgrade() {

	if [ -f /usr/bin/parity ] ; then
		OLD_VERSION=$(parity --version | grep version|  cut -d/ -f2  | cut -d- -f1 | sed 's/v//g')
	else
		OLD_VERSION="0.0.0"
	fi

	if [ "$PKG" = "linux" ] ; then
		FILE=$(curl -Ss $LOOKUP_URL | grep amd | cut -d "(" -f2 | cut -d ")" -f1)
		NEW_VERSION=$(basename $FILE | cut -d_ -f2)
	fi

	if [ "$PKG" = "debian" ] ; then
		NEW_VERSION=$(basename $DOWNLOAD_FILE  |  cut -d_ -f2)
	fi

	if [ "$PKG" = "centos" ] ; then
	    NEW_VERSION=$(basename $DOWNLOAD_FILE  |  cut -d_ -f2)

	fi

	if [ "$PKG" = "darwin" ] ; then
		NEW_VERSION=$(basename $DOWNLOAD_FILE | cut -d- -f2)
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

    TMPDIR=$(mktemp -d)
    cd $TMPDIR
	$(curl -Ss -O $DOWNLOAD_FILE)

	if [ "$PKG" = "debian" ] ; then
		NAME=$(basename $DOWNLOAD_FILE)
		sudo dpkg -i $TMPDIR/$NAME
	fi

	if [ "$PKG" = "linux" -a $LIBSSL = "10" ] ; then
		NAME=$(basename $DOWNLOAD_FILE)
		sudo dpkg -i $TMPDIR/$NAME
	fi

	if [ "$PKG" = "linux" -a $LIBSSL = "undef" ] ; then
	    sudo cp $TMPDIR/parity /usr/bin
		sudo chmod +x /usr/bin/parity
	fi

        if [ "$PKG" = "centos" ] ; then
	    NAME=$(basename $DOWNLOAD_FILE)
	    sudo rpm -U $TMPDIR/$NAME
	fi

	if [ "$PKG" = "darwin" ] ; then
		NAME=$(basename $DOWNLOAD_FILE)
		sudo /usr/sbin/installer -pkg $TMPDIR/$NAME -target / && \
		sudo ln -sF /Applications/Parity\ Ethereum.app/Contents/MacOS/parity /usr/local/bin/parity
	fi

}


version_gt() {
	test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}



help() {

	echo "Usage is: -r --release [ stable / beta / nightly ]"

}

# curl installed? 
which curl &> /dev/null 
if [[ $? -ne 0 ]] ; then
    echo '"curl" binary not found, please install and retry'
    exit 1
fi

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
