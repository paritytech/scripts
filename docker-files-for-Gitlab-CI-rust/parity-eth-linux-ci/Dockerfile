# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier

# temporary support of 16.04 with its Clib
FROM ubuntu:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="This is for CI build stage for Parity Ethereum linux binary." \
	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
	url="https://gitlab.com/paritytech"

# install tools and dependencies
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake ca-certificates g++ rhash \
	gcc pkg-config libudev-dev time \
	libssl-dev
# libssl-dev won't be needed in rust:stretch

# install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get -y update && apt-get install -y --no-install-recommends \
	nodejs yarn

WORKDIR /builds/parity/parity-ethereum/

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH=/root/.cargo/bin:$PATH

RUN cargo install cargo-audit sccache

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
	CARGO_TARGET=x86_64-unknown-linux-gnu \
	CARGO_HOME=/cargo \
# cache handler
	RUSTC_WRAPPER=sccache \
	SCCACHE_DIR=/cargo/sccache \
# show backtraces
	RUST_BACKTRACE=1

# pre-download repositories
# RUN git clone https://github.com/paritytech/parity-ethereum.git . && \
RUN git clone https://gitlab.parity.io/parity/parity-ethereum.git/ . && \
	git submodule update --init --recursive
