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

# install aarch64(armv8) dependencies and tools
RUN dpkg --add-architecture arm64
RUN echo '# source urls for arm64 \n\
    deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
    deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
    deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
    deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
    deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
    deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n # end arm64 section' >> /etc/apt/sources.list &&\
    sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
    cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
    sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&& \
    cat /etc/apt/sources.list &&\
    cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
    echo "next"&&cat /etc/apt/sources.list

RUN apt -y update && \
		apt install -y \
		g++-aarch64-linux-gnu gcc-aarch64-linux-gnu libudev-dev libudev-dev:arm64

# install aarch64 toolchain
RUN rustup target add aarch64-unknown-linux-gnu

# set cross-compiler ENV
ADD config /.cargo/config
ENV CC=aarch64-linux-gnu-gcc \
		CXX=aarch64-linux-gnu-g++ \
		CARGO_TARGET=aarch64-unknown-linux-gnu \
		CARGO_HOME=/parity-ethereum/.cargo/ \
		HOST_CC=gcc \
		HOST_CXX=g++ \
		LDFLAGS="-L/usr/lib/arm-linux-aarch64" \
		CPPFLAGS="-I/usr/include"
