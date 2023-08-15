# Image with dependencies required to build projects from the bridge repo.
#
# This image is meant to be used as a building block when building images for
# the various components in the bridge repo, such as nodes and relayers.
ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/bridges-ci" \
	io.parity.image.description="CI image with all dependencies for parity-bridges-common compilation." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/bridges-ci/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/bridges-ci/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN rustup component add clippy && \
    rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component clippy rustfmt && \
	rustup target add wasm32-unknown-unknown && \
	cargo install cargo-deny cargo-spellcheck && \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" && \
# versions
	rustc -vV && \
	cargo -V && \
	cargo clippy -V

USER nonroot:nonroot
