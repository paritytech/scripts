# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-substrate-build" \
	description="Image for Substrate CI builds and tests." \
	url="https://github.com/paritytech/scripts/" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/substrate-linux-ci"

WORKDIR /builds/parity/substrate/

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		git g++ clang cmake make \
		pkg-config libssl-dev \
		curl time; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# setup default stable channel
	rustup default stable; \
	cargo install cargo-audit sccache; \
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
