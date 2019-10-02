FROM parity/rust-builder:latest

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/ink-ci-linux" \
	io.parity.image.description="inherits from rust-builder; rust nightly-2019-08-30 clippy rustfmt" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

RUN rustup default nightly-2019-08-30; \
    rustup target add wasm32-unknown-unknown; \
    rustup component add clippy rustfmt
