FROM debian:buster

# metadata
ARG VCS_REF
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech

ENV VCS_REF=${VCS_REF:-"master"}
ENV BUILD_DATE=${BUILD_DATE:-""}
ENV REGISTRY_PATH=${REGISTRY_PATH:-paritytech}

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/base-ci-linux" \
	io.parity.image.description="Layer 1 image with all dependencies for Rust and WASM compilation. \
libssl-dev, clang, libclang-dev, lld, cmake, make, git, pkg-config \
curl, time, rhash, rust stable, rust nightly, sccache" \
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

# download rustup
ADD "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" rustup-init

# install tools and dependencies
RUN set -eux; \
	apt -y update; \
	apt install -y --no-install-recommends \
		libssl-dev clang lld libclang-dev make cmake \
		git pkg-config curl time rhash ca-certificates; \
# set a link to clang
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
# install rustup
  	chmod +x rustup-init; \
  	./rustup-init -y --no-modify-path --default-toolchain stable; \
  	rm rustup-init; \
  	chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
# install Rust nightly, default is stable
	rustup install nightly; \
# install sccache
	cargo install sccache --features redis; \
# versions
	rustup show; \
	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf $CARGO_HOME/registry; \
# removes toolchain's html docs and autocompletions (>300M for each toolchain)
	rm -rf /usr/local/rustup/toolchains/*/share; \
# apt clean up
	apt autoremove -y; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*
# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
  	RUST_BACKTRACE=1
