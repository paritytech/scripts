#!/bin/bash
# Install all required dependencies for building Substrate based chains on ARM architecture.
# Copyright (C) Parity Technologies <admin@parity.io>
# License: Apache-2.0

# Set to the latest branch from: https://github.com/rust-lang/llvm-project
RUST_LLVM_BRANCH="rustc/9.0-2019-09-19"

if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
	set -e
	if [[ `whoami` == "root" ]]; then
		MAKE_ME_ROOT=
	else
		MAKE_ME_ROOT=sudo
	fi

    ARCH=`uname -m`

    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "armv7l" ]]; then

	    if [ -f /etc/debian_version ]; then
		    echo "Ubuntu/Debian Linux detected."
		    $MAKE_ME_ROOT apt update
		    $MAKE_ME_ROOT apt-get install -y --no-install-recommends \
				            build-essential \
				            ninja-build \
				            ca-certificates \
				            cmake \
				            pkg-config \
				            libssl-dev \
				            gcc \
				            git \
				            clang \
				            libclang-dev \
				            protobuf-compiler

	    else
		    echo "This Linux distribution is not supported with this script at present. Sorry."
		    echo "Please refer to https://github.com/paritytech/substrate for setup information."
		    exit 1
        fi

        echo "Building llvm-ld for: $ARCH"

	    if ! which rustup >/dev/null 2>&1; then
		    curl https://sh.rustup.rs -sSf | sh -s -- -y
		    source ~/.cargo/env
		    rustup default stable
	    else
		    rustup update
		    rustup default stable
	    fi

	    rustup update nightly --force
	    rustup target add wasm32-unknown-unknown --toolchain nightly

	    tmp=`mktemp -d`
	    git clone https://github.com/rust-lang/llvm-project.git $tmp
	    pushd $tmp
	    git checkout -b $RUST_LLVM_BRANCH --track origin/$RUST_LLVM_BRANCH
	    mkdir -p llvm/tools/lld
	    cp -R lld/ llvm/tools/
	    mkdir -p $tmp/build/arm
	    cd $tmp/build/arm
	    if [ "$ARCH" == "aarch64" ] ; then
		    cmake -G Ninja $tmp/llvm \
			    -DCMAKE_BUILD_TYPE=Release \
			    -DCMAKE_INSTALL_PREFIX=/opt/local/llvm \
			    -DLLVM_TARGETS_TO_BUILD="AArch64" \
			    -DLLVM_TARGET_ARCH="AArch64"
	    else
		    cmake -G Ninja $tmp/llvm \
			    -DCMAKE_BUILD_TYPE=Release \
			    -DCMAKE_INSTALL_PREFIX=/opt/local/llvm \
			    -DLLVM_TARGETS_TO_BUILD="ARM" \
			    -DLLVM_TARGET_ARCH="ARM"
	    fi
	    ninja lld
	    $MAKE_ME_ROOT ninja install-lld
	    popd

	    echo "Installing rust-lld for: $ARCH"
	    cp -f /opt/local/llvm/bin/ld.lld ~/.cargo/bin/rust-lld
	    source ~/.cargo/env

	    echo "Run source ~/.cargo/env now to update environment"

    else
	    echo "This architecture is not supported with this script at present. Sorry."
	    echo "Please refer to https://github.com/paritytech/substrate for setup information."
	    exit 1
    fi

else
    echo "This OS is not supported with this script at present. Sorry."
    echo "Please refer to https://github.com/paritytech/substrate for setup information."
    exit 1
fi

