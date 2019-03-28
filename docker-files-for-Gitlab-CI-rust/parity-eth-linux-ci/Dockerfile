# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim as notifier

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
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# install tools and dependencies
RUN apt-get -y update; \
	apt-get install -y --no-install-recommends \
		software-properties-common curl git \
		make cmake ca-certificates g++ rhash \
		gcc pkg-config libudev-dev time \
		libssl-dev libc6-dev wget; \
# libssl-dev won't be needed in rust:stretch
# install rustup
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
	rustup install nightly beta; \
	rustup default stable; \
	cargo install cargo-audit sccache; \
# apt clean up
    apt-get remove -y --auto-remove \
        wget; \
	rm -rf /var/lib/apt/lists/*

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
	CARGO_TARGET=x86_64-unknown-linux-gnu \
# cache handler
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/parity-ethereum/cargo \
	SCCACHE_DIR=/ci-cache/parity-ethereum/sccache \
# show backtraces
	RUST_BACKTRACE=1
