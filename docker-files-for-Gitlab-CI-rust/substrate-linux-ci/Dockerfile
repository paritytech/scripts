# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim as notifier

FROM ubuntu:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-substrate-build" \
	description="Image for Substrate CI builds and tests." \
	url="https://github.com/paritytech/scripts/" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/substrate-linux-ci"

WORKDIR /builds/parity/substrate/

# rustup directory
ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		wget git ca-certificates gcc g++ clang \
		pkg-config libssl-dev cmake libc6-dev; \
# needed: wget ca-certificates gcc g++ libssl-dev pkg-config git cmake clang
# not needed: software-properties-common curl make rhash libudev-dev time
# install rustup
	url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
	wget "$url"; \
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path --default-toolchain stable; \
	rm rustup-init; \
	chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
	rustup install nightly beta; \
	cargo install cargo-audit sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install wasm toolchain for polkadot
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# Install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc;

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handlers
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/substrate/cargo \
	SCCACHE_DIR=/ci-cache/substrate/sccache \
# show backtraces
	RUST_BACKTRACE=1
