# DockerHub's official https://hub.docker.com/_/rust
FROM rust:slim-buster

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/base-ci-linux" \
	io.parity.image.description="Layer 1 image with all dependencies for Rust and WASM compilation. \
g++ libssl-dev gcc clang-9 libclang-9-dev cmake make git pkg-config curl time rhash \
rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown
COPY config /root/.cargo/config
# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 9 has WASM support enabled by default.
COPY clang9.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg
# download cmake
ADD "https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.sh" cmake.sh
# install tools and dependencies
RUN set -eux; \
	echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	DEBIAN_FRONTEND=noninteractive apt-get -y update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		g++ libssl-dev gcc clang-9 libclang-9-dev make \
		git pkg-config curl time rhash; \
# set a link to clang-9
	ln -s /usr/bin/clang-9 /usr/bin/clang; \
# install cmake
  echo "c87dc439a8d6b1b368843c580f0f92770ed641af8ff8fe0b706cfa79eed3ac91 cmake.sh" | sha256sum -c - || exit 1; \
	chmod +x cmake.sh; \
	./cmake.sh --skip-license --prefix=/usr/ --exclude-subdir; \
# versions
	cmake --version; \
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
	rm -rf /var/lib/apt/lists/*; \
	rm cmake.sh
