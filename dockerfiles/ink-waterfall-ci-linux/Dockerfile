ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/ink-ci-linux:production

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-waterfall-ci-linux" \
	io.parity.image.description="Inherits from paritytech/ink-ci-linux." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-waterfall-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-waterfall-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

RUN	set -eux; \
	apt-get -y update && \
# The ink! repository is needed for the `examples/`
	git clone --depth 1 https://github.com/paritytech/ink.git . && \
# `cargo-contract` is needed for building those examples
	cargo install --force --git https://github.com/paritytech/cargo-contract && \
# `canvas-node` is a Substrate chain with smart contract functionality
	cargo install canvas-node --git https://github.com/paritytech/canvas-node.git --locked && \
# versions
	rustup show && \
	cargo --version && \
	cargo-contract --version && \
	canvas --version && \
# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \
# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
