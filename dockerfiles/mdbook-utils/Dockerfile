FROM docker.io/library/debian:stable-slim

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# metadata
LABEL summary="Image with mdbook utils" \
    name="${REGISTRY_PATH}/mdbook-utils" \
    maintainer="cicd-team@parity.io" \
    version="1.0" \
    description="Image with mdbook utils" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/mdbook-utils/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/mdbook-utils/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git curl build-essential libssl-dev perl gcc graphviz ca-certificates && \
    # install rustup, use minimum components
    curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" -o rustup-init && \
    chmod +x rustup-init && \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable && \
    rm rustup-init && \
    cargo install mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed
