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
#  - cargo: General build tool.
#  - rustfmt: Rust formatting tool.
#  - clippy: Rust linter.
#  - miri: Rust interpreter with additional safety checks.
#
# We also need to install the wasm32-unknown-unknown target to test
# ink! smart contracts compilation for this target architecture.
#
# Only Rust nightly builds supporting all of the above mentioned components
# and targets can be used for this docker image.
#
# Visit https://rust-lang.github.io/rustup-components-history/ to see which
# components are available for which nightly build.
	rustup default nightly-2020-05-30; \
	# Install wasm32 target for this toolchain
	rustup target add wasm32-unknown-unknown; \
	rustup component add rustfmt clippy miri rust-src; \
	# We require `xargo` so that `miri` runs properly
	# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
	cargo install grcov rust-covfix cargo-contract xargo; \
	rustup show; \
	cargo --version; \
	# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	# Also removes toolchain's HTML, docs and autocompletions (>300M for each toolchain).
	rm -rf $CARGO_HOME/registry; \
	rm -rf /usr/local/rustup/toolchains/*/share;
