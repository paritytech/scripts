ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/contracts-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
llvm-dev, clang, zlib1g-dev, npm, yarn, wabt, binaryen. \
rust nightly, rustfmt, clippy, rust-src, solang, canvas-node" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# install tools and dependencies
RUN set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends \
		zlib1g-dev npm wabt llvm-dev && \
	npm install --ignore-scripts -g yarn && \
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
# Installs the latest common nightly for the listed components,
# adds those components, wasm target and sets the profile to minimal
	rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy rust-src && \
	rustup default nightly && \
	cargo install pwasm-utils-cli --bin wasm-prune && \
	cargo install cargo-contract && \
# tried v0.1.5 and the latest master - both fail with https://github.com/hyperledger-labs/solang/issues/314
	cargo install --git https://github.com/hyperledger-labs/solang --tag v0.1.2 && \
# download the latest canvas-node binary
	curl -L "https://gitlab.parity.io/parity/canvas-node/-/jobs/artifacts/master/raw/artifacts/canvas-linux/canvas?job=build-linux" \
		-o /usr/local/cargo/bin/canvas && \
	chmod +x /usr/local/cargo/bin/canvas && \
# versions
	yarn --version && \
	rustup show && \
	cargo --version && \
	solang --version && \
	canvas --version && \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \
# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# TODO: https://gitlab.parity.io/parity/cargo-contract/-/jobs/958744, https://gitlab.parity.io/parity/cargo-contract/-/jobs/958745
# USER nonroot:nonroot
