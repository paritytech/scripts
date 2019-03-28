# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim

# temporary support of 16.04 with its Clib
FROM ubuntu:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="Image for CI build stage for Parity Ethereum linux binary." \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci"

WORKDIR /builds/parity/parity-ethereum/

# rustup directory
ENV PATH=/root/.cargo/bin:$PATH \
# compiler ENV
	CC=gcc \
	CXX=g++ \
	CARGO_TARGET=x86_64-unknown-linux-gnu \
# cache handler
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/parity-ethereum/cargo \
	SCCACHE_DIR=/ci-cache/parity-ethereum/sccache \
# show backtraces
	RUST_BACKTRACE=1

# install tools and dependencies
RUN apt-get -y update; \
	apt-get install -y --no-install-recommends \
		software-properties-common curl git \
		make cmake ca-certificates g++ rhash \
		gcc pkg-config libudev-dev time \
		libssl-dev; \
# libssl-dev won't be needed in rust:stretch
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install rustup
	curl https://sh.rustup.rs -sSf | sh -s -- -y; \
	cargo install cargo-audit sccache; \
	rustup install nightly beta
