# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim

# metadata
# LABEL maintainer="devops-team@parity.io" \
# 	vendor="Parity Technologies" \
# 	name="parity/rust-parity-ethereum-build" \
# 	description="This is for CI build stage for Parity Ethereum linux binary." \
# 	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
# 	url="https://gitlab.com/paritytech"

# install tools and dependencies
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake ca-certificates g++ rhash \
	gcc pkg-config libudev-dev time \
	libssl-dev

WORKDIR /builds/parity/substrate/

RUN cargo install cargo-audit sccache

# install wasm toolchain for polkadot
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
# Install wasm-gc. It's useful for stripping slimming down wasm binaries.
# (polkadot)
RUN cargo +nightly install --git https://github.com/alexcrichton/wasm-gc
# setup default stable channel
RUN rustup default stable

# show backtraces
ENV RUST_BACKTRACE 1
#compiler ENV
ENV CC gcc
ENV CXX g++

# #
# git clone https://github.com/paritytech/substrate.git .
# rustup target add wasm32-unknown-unknown --toolchain nightly
# cargo +nightly install --git https://github.com/alexcrichton/wasm-gc
# scripts/build.sh
# #
# time rustup default nightly
