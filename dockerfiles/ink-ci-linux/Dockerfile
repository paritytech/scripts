ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-ci-linux" \
	io.parity.image.description="Inherits from paritytech/base-ci. \
rust nightly, clippy, rustfmt, miri, rust-src grcov, rust-covfix, cargo-contract, xargo, binaryen" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV CXX=/usr/bin/clang++-10
ENV DEBIAN_FRONTEND=noninteractive

RUN	set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends \
# hunspell is needed for automated spell-checking
	hunspell hunspell-en-us && \
# binaryen is needed by cargo-contract for optimizing Wasm files
# we fetch the latest version number from the GitHub API and use that release
	curl --silent https://api.github.com/repos/WebAssembly/binaryen/releases/latest | \
		egrep --only-matching 'https://github.com/WebAssembly/binaryen/releases/download/version_[0-9]+/binaryen-version_[0-9]+-x86_64-linux.tar.gz' | \
		head -n1 | \
		xargs curl -L -O && \
	tar -xvzf binaryen-version_*-x86_64-linux.tar.gz  && \
	rm binaryen-version_*-x86_64-linux.tar.gz && \
	chmod +x binaryen-version_*/bin/wasm-opt && \
	mv binaryen-version_*/bin/wasm-opt /usr/local/bin/ && \
	rm -rf binaryen-version_*/ && \
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
# Installs the latest common nightly for the listed components,
# adds those components, wasm target and sets the profile to minimal
	rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy miri rust-src && \
	rustup default nightly && \
# We require `xargo` so that `miri` runs properly
# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
# We require `cargo-spellcheck` for automated spell-checking
	cargo install grcov rust-covfix xargo cargo-spellcheck && \
	cargo install cargo-contract && \
# versions
	rustup show && \
	cargo --version && \
	cargo-contract --version && \
# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \
# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
