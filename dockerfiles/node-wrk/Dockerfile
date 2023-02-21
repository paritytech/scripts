FROM debian:buster-slim as builder

# metadata
ARG VCS_REF
ARG BUILD_DATE
ARG IMAGE_NAME="staking-miner"
ARG PROFILE=release

LABEL description="This is the build stage. Here we create the binary."

WORKDIR /build

RUN set -eux && \
    apt-get update && \
    apt-get install -y build-essential git curl clang libclang-dev pkg-config libssl-dev unzip lua5.1 liblua5.1-0-dev && \
    git clone https://github.com/wg/wrk.git wrk && \
    cd wrk && \
    make

# ===== SECOND STAGE ======

ARG VCS_REF=master
ARG BUILD_DATE=""

FROM node:18-slim

LABEL summary="Image for Substrate-api-sidecar benchmarks" \
	name="${REGISTRY_PATH}/sidecar-bench" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="node image with wrk for benchmarks" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/sidecar-bench/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/sidecar-bench/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

COPY --from=builder /build/wrk/wrk /usr/local/bin
