# DockerHub's official https://hub.docker.com/_/rust
FROM rust:slim-stretch

ARG VCS_REF
ARG BUILD_DATE

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-builder" \
	io.parity.image.description="git g++ clang cmake make pkg-config libssl-dev curl time rhash \
		rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/rust-builder/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/rust-builder/README.md"

WORKDIR /builds

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		git g++ clang cmake make \
		pkg-config libssl-dev \
		curl time rhash; \
# install Rust nightly, default is stable
	rustup install nightly; \
# install cargo tools
	cargo install cargo-audit sccache; \
# install wasm toolchain for polkadot
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc; \
# versions
	rustup show; \
	cargo --version; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*;

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
