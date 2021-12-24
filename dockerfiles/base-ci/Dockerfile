FROM docker.io/library/ubuntu:20.04

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# metadata
LABEL summary="Layer 1 image with all dependencies for Rust and WASM compilation." \
	name="${REGISTRY_PATH}/base-ci" \
	maintainer="devops-team@parity.io" \
	version="2.0" \
	description="libssl-dev, clang, libclang-dev, lld, cmake, make, git, pkg-config \
curl, time, rhash, ca-certificates, jq, rust stable, sccache" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/base-ci/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/base-ci/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown & clang
COPY utility/base-ci-linux-config /root/.cargo/config

ENV RUSTUP_HOME=/usr/local/rustup
ENV	CARGO_HOME=/usr/local/cargo
ENV	PATH=/usr/local/cargo/bin:$PATH
ENV	CC=clang-10
ENV CXX=/usr/bin/clang++-10
ENV	DEBIAN_FRONTEND=noninteractive

# install tools and dependencies
RUN set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends \
		libssl-dev clang lld libclang-dev make cmake \
		git pkg-config curl time rhash ca-certificates \
		jq ruby git-restore-mtime python3-pip xz-utils && \
# add non-root user
  groupadd -g 1000 nonroot && \
  useradd -u 1000 -g 1000 -s /bin/bash -m nonroot && \
# install minio client
	curl -L "https://dl.min.io/client/mc/release/linux-amd64/mc" -o /usr/local/bin/mc && \
	chmod 755 /usr/local/bin/mc && \
# set a link to clang
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100 && \
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang-10 100 && \
	update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-10 100 && \
# install rustup, use minimum components
	curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
		-o rustup-init && \
  	chmod +x rustup-init && \
  	./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable && \
  	rm rustup-init && \
    chown -R root:nonroot ${RUSTUP_HOME} ${CARGO_HOME} && \
  	chmod -R g+w ${RUSTUP_HOME} ${CARGO_HOME} && \
# install sccache
	# cargo install sccache --features redis && \
	# FIXME: TEMPORARY OVERRIDE due to the sccache issue
	# https://github.com/mozilla/sccache/issues/663
	cargo install --git https://github.com/mozilla/sccache  --rev 6628e1f70db3d583cb5e79210603ad878de3d315 --features redis && \
# versions
	rustup show && \
	cargo --version && \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \
# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
  rm -rf /var/lib/apt/lists/*
# cache handler
ENV	RUSTC_WRAPPER=sccache
# show backtraces
ENV RUST_BACKTRACE=1
