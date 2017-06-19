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

install_package() {

   case "$PKG" in
    debian) install_debian ;;
    linux) install_linux ;;
    darwin) install_darwin;;
    *) echo "Unkown o/s" ;;
   esac

}

install() {

   TMPDIR=$(mktemp -d)
   cd $TMPDIR
   $(wget $DOWNLOAD_FILE)
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

help() {

echo "Usage is: -b --build [ stable / beta / nightly ]"

}


while [ "$1" != "" ]; do
    case $1 in
        -b | --build )           shift
                                ;;
        * )                     help
                                exit 1
    esac
    shift
done


echo "Build selected is: $BUILD"

check_os
get_package
install
