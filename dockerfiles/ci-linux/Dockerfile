ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

ARG RUST_NIGHTLY="2023-01-01"

# metadata
LABEL summary="Image for Substrate-based projects." \
	name="${REGISTRY_PATH}/ci-linux" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Inherits from base-ci-linux; wasm-gc, wasm-bindgen-cli, wasm-pack, cargo-audit, cargo-web, cargo-deny" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

# install tools and dependencies
RUN set -eux && \
	# install `rust-src` component for ui test
	rustup component add rust-src rustfmt clippy && \
	# install wasm target into default (stable) toolchain
	rustup target add wasm32-unknown-unknown && \
	# install specific Rust nightly, default is stable, use minimum components
	rustup toolchain install "nightly-${RUST_NIGHTLY}" --profile minimal --component rustfmt && \
	# install wasm target into nightly toolchain
	rustup target add wasm32-unknown-unknown --toolchain "nightly-${RUST_NIGHTLY}" && \
	# "alias" pinned nightly toolchain as nightly
	ln -s "/usr/local/rustup/toolchains/nightly-${RUST_NIGHTLY}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \
	# install cargo tools
	cargo install cargo-web wasm-pack cargo-deny cargo-spellcheck cargo-hack \
	  mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed && \
	cargo install cargo-nextest --locked && \
	# diener 0.4.6 NOTE: before upgrading please test new version with companion build
	# example can be found here: https://github.com/paritytech/substrate/pull/12710
	cargo install diener --version 0.4.6 && \
	# wasm-bindgen-cli version should match the one pinned in substrate
	# https://github.com/paritytech/substrate/blob/master/bin/node/browser-testing/Cargo.toml#L15
	cargo install --version 0.2.73 wasm-bindgen-cli && \
	# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo install wasm-gc && \
	# install cargo hfuzz and honggfuzz dependencies
	apt-get -y update && \
	apt-get install -y binutils-dev libunwind-dev libblocksruntime-dev && \
	cargo install honggfuzz && \
	# versions
	rustup show && \
	cargo --version && \
	# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	# cargo clean up
	# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache
