# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim

ARG VCS_REF
ARG BUILD_DATE

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/substrate-ci" \
	io.parity.image.description="git g++ clang cmake make pkg-config libssl-dev curl time rhash \
		rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/substrate-ci/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/substrate-ci/README.md"

WORKDIR /builds

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		git g++ clang cmake make \
		pkg-config libssl-dev \
		curl time rhash; \
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
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
