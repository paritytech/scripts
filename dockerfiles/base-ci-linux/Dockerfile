FROM docker.io/library/debian:bullseye-slim

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

ARG DEBIAN_CODENAME=bullseye

# metadata
LABEL summary="Layer 1 image with all dependencies for Rust and WASM compilation." \
	name="${REGISTRY_PATH}/base-ci-linux" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="libssl-dev, clang, libclang-dev, lld, cmake, make, git, pkg-config \
curl, time, jq, lsof, rhash, rust stable, rust nightly, sccache" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/base-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/base-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# config for wasm32-unknown-unknown & clang
COPY utility/base-ci-linux-config /root/.cargo/config
COPY utility/debian-llvm-clang.key /etc/apt/trusted.gpg.d/debian-llvm-clang.gpg

ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH \
		CC=clang-14 \
		CXX=clang-14

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		libssl-dev make cmake graphviz \
		git pkg-config curl time rhash ca-certificates jq \
		python3 python3-pip lsof ruby ruby-bundler git-restore-mtime xz-utils zstd unzip gnupg protobuf-compiler && \
# add clang 14 repo
	echo "deb http://apt.llvm.org/${DEBIAN_CODENAME}/ llvm-toolchain-${DEBIAN_CODENAME}-14 main" >> /etc/apt/sources.list.d/llvm-toochain-${DEBIAN_CODENAME}-14.list; \
	echo "deb-src http://apt.llvm.org/${DEBIAN_CODENAME}/ llvm-toolchain-${DEBIAN_CODENAME}-14 main" >> /etc/apt/sources.list.d/llvm-toochain-${DEBIAN_CODENAME}-14.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		clang-14 lldb-14 lld-14 libclang-14-dev && \
# add non-root user
  groupadd -g 1000 nonroot && \
  useradd -u 1000 -g 1000 -s /bin/bash -m nonroot && \
# install minio client
  curl -L "https://dl.min.io/client/mc/release/linux-amd64/mc" -o /usr/local/bin/mc && \
  chmod 755 /usr/local/bin/mc && \
# set a link to clang
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang-14 100; \
# set a link to ldd
  update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld-14 100; \
# install rustup, use minimum components
	curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
		-o rustup-init; \
  	chmod +x rustup-init; \
  	./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable; \
  	rm rustup-init; \
    chown -R root:nonroot ${RUSTUP_HOME} ${CARGO_HOME}; \
  	chmod -R g+w ${RUSTUP_HOME} ${CARGO_HOME}; \
# install sccache
	cargo install sccache; \
# versions
	rustup show; \
	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
  rm -rf /var/lib/apt/lists/*
# show backtraces
ENV	RUST_BACKTRACE=1
