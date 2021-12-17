FROM docker.io/library/debian:buster-slim

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# those can be removed once jq is available through the distribution
ARG JQ_CHECKSUM=af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44
ARG JQ_PATH=/bin/jq

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

# config for wasm32-unknown-unknown & clang
COPY utility/base-ci-linux-config /root/.cargo/config

ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH \
		CC=clang \
		CXX=clang

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		libssl-dev clang lld libclang-dev make cmake \
		git pkg-config curl time rhash ca-certificates \
		python3 python3-pip lsof ruby git-restore-mtime; \
# install recent jq; this step can be removed once jq >= 1.6 is available
# through the distribution
  curl -sqL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o "$JQ_PATH" && \
  chmod +x "$JQ_PATH" && \
  echo "$JQ_CHECKSUM $JQ_PATH" | sha256sum --check && \
  jq --version; \
# install minio client
  curl -L "https://dl.min.io/client/mc/release/linux-amd64/mc" -o /usr/local/bin/mc \
  && chmod 755 /usr/local/bin/mc \
# set a link to clang
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
# install rustup, use minimum components
	curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
		-o rustup-init; \
  	chmod +x rustup-init; \
  	./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable; \
  	rm rustup-init; \
  	chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}; \
# install sccache
	# cargo install sccache --features redis; \
	# FIXME: TEMPORARY OVERRIDE due to the sccache issue
	# https://github.com/mozilla/sccache/issues/663
	cargo install --git https://github.com/mozilla/sccache  --rev 6628e1f70db3d583cb5e79210603ad878de3d315 --features redis; \
# versions
	rustup show; \
	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
  rm -rf /var/lib/apt/lists/*; \
# add non-root user
  groupadd -g 1000 nonroot; \
  useradd -u 1000 -g 1000 -s /bin/bash -m nonroot
# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
  	RUST_BACKTRACE=1
