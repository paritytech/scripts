# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier

# temporary support of 16.04 with its Clib
FROM parity/rust-parity-ethereum-build:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="This is for CI build stage for Parity Ethereum linux binary." \
	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
	url="https://gitlab.com/paritytech"

	# install armv7 dependencies and tools
	RUN dpkg --add-architecture armhf
	RUN	echo '# source urls for armhf \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n # end armhf section' >> /etc/apt/sources.list &&\
		sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
		cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
		sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&& \
		cat /etc/apt/sources.list && \
	  cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
		echo "next"&&cat /etc/apt/sources.list

RUN apt -y update && \
		apt install -y \
		g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf libudev-dev libudev-dev:armhf

# install armv7 toolchain
RUN rustup target add armv7-unknown-linux-gnueabihf

# set cross-compiler ENV
ADD config /.cargo/config
ENV CC=arm-linux-gnueabihf-gcc \
		CXX=arm-linux-gnueabihf-g++ \
		CARGO_TARGET=armv7-unknown-linux-gnueabihf \
		CARGO_HOME=/parity-ethereum/.cargo/ \
		HOST_CC=gcc \
		HOST_CXX=g++ \
		LDFLAGS="-L/usr/lib/arm-linix-gnueabihf" \
		CPPFLAGS="-I/usr/include"
