ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
rust nightly, clippy, rustfmt, cargo-kcov, cargo-contract" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN	set -eux; \
# The supported Rust nightly version must support the following components
# to allow for a functioning CI pipeline:
#
#  - cargo
#  - rustfmt
#  - clippy
#  - miri (in the future)
# see on https://rust-lang.github.io/rustup-components-history/
	rustup default nightly-2020-05-07; \
# install wasm32 target for this toolchain
	rustup target add wasm32-unknown-unknown; \
# install cargo tools
	rustup component add rustfmt clippy; \
	cargo install grcov rust-covfix; \
	cargo install --git https://github.com/paritytech/cargo-contract; \
# versions
	rustup show; \
	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf $CARGO_HOME/registry; \
# removes toolchain's html docs and autocompletions (>300M for each toolchain)
	rm -rf /usr/local/rustup/toolchains/*/share;
