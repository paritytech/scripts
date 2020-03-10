# DockerHub's official https://hub.docker.com/_/rust
FROM debian:buster

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/base-ci-linux" \
	io.parity.image.description="Layer 1 image with all dependencies for Rust and WASM compilation. \
libssl-dev clang-9 libclang-9-dev lld-9 cmake make git pkg-config \
curl time rhash rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown & clang
COPY utility/base-ci-linux-config /root/.cargo/config

# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 9 has WASM support enabled by default.
COPY utility/debian-llvm-clang9.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg

ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH \
		CC=clang \
		CXX=clang

# download rustup
ADD "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" rustup-init

# install tools and dependencies
RUN set -eux; \
	echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		libssl-dev clang-9 lld-9 libclang-9-dev make cmake \
		git pkg-config curl time rhash ca-certificates; \
# set a link to clang-9
	ln -s /usr/bin/clang-9 /usr/bin/clang; \
	ln -sf /usr/bin/clang-9 /usr/bin/cc; \
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
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
  	RUST_BACKTRACE=1
