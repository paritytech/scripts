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

# install i386 dependencies and tools
RUN dpkg --add-architecture i386

RUN apt -y update && \
		apt install -y \
		gcc-multilib g++-multilib libudev-dev libudev-dev:i386

# install i686 toolchain
RUN rustup target add i686-unknown-linux-gnu

# set cross-compiler ENV
ENV CC=gcc \
		CXX=g++ \
		CARGO_TARGET=i686-unknown-linux-gnu \
		CARGO_HOME=/parity-ethereum/.cargo/ \
		HOST_CC=gcc \
		HOST_CXX=g++ \
		LDFLAGS="-L/usr/lib32" \
		CPPFLAGS="-I/usr/include"
