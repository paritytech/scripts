ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

# `production` tag is used here to base off the image that has already been tested against
# the `ink` CI. This reduces the maintenance of fixing the same nightly stuff in both images.
FROM ${REGISTRY_PATH}/ink-ci-linux:production

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/smart-bench-ci" \
	io.parity.image.description="Inherits from docker.io/paritytech/ink-ci-linux." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
	dockerfiles/smart-bench-ci/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
	dockerfiles/smart-bench-ci/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

RUN	set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends && \
	# `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
	cargo install cargo-dylint dylint-link && \
	# `cargo-contract` is needed for building those examples. Here it's
	# force-rewritten above the stable version from the parent image.
	# `--force` rewrites the stable version installed in the parent image.
	# `--locked` ensures the project's `Cargo.lock` is used.
	cargo install --git https://github.com/paritytech/cargo-contract \
	--locked --branch master --force && \
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

# TODO: https://gitlab.parity.io/parity/infrastructure/scripts/-/jobs/958687
# USER nonroot:nonroot
