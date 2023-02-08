ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/library/rust:latest

# metadata
LABEL summary="Cross Builder for aarch64-unknown-linux-gnu targets" \
	name="${REGISTRY_PATH}/xbuilder-aarch64-unknown-linux-gnu" \
	version="1.0" \
	description="Parity xbuilder-aarch64-unknown-linux-gnu container" \
	maintainer="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
    io.parity.image.authors="chevdor@gmail.com, devops-team@parity.io" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/parity-keyring/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/parity-keyring/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

USER root

RUN apt update && apt upgrade -y && \
    apt install -y \
        g++-aarch64-linux-gnu libc6-dev-arm64-cross \
        pkg-config libssl-dev \
        protobuf-compiler clang make bsdmainutils && \
        rm -rf /var/lib/apt/lists/* /tmp/* && apt clean && \
    rustup target add aarch64-unknown-linux-gnu && \
    rustup toolchain install stable-aarch64-unknown-linux-gnu

WORKDIR /app

ENV SKIP_WASM_BUILD=1 \
    CC_aarch64_unknown_linux_gnu="aarch64-linux-gnu-gcc" \
    CXX_aarch64_unknown_linux_gnu="aarch64-linux-gnu-g++" \
    BINDGEN_EXTRA_CLANG_ARGS="-I/usr/aarch64-linux-gnu/include/" \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="aarch64-linux-gnu-gcc"

ENTRYPOINT ["cargo", "build", "--target", "aarch64-unknown-linux-gnu"]
