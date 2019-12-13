# DockerHub's official https://hub.docker.com/_/rust
FROM rust:slim-buster

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-builder" \
	io.parity.image.description="g++ libssl-dev gcc clang-9 libclang-9-dev cmake make git pkg-config \
curl time rhash rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown
COPY rust-builder/config /root/.cargo/config

# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 9 has WASM support enabled by default.
COPY utility/debian-llvm-clang9.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg

# copy cmake
COPY utility/cmake.sh cmake.sh

# install tools and dependencies
RUN set -eux; \
	echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		g++ libssl-dev gcc clang-9 libclang-9-dev make \
		git pkg-config curl time rhash; \
# set a link to clang-9
	ln -s /usr/bin/clang-9 /usr/bin/clang; \
# install cmake
	./cmake.sh --skip-license --prefix=/usr/ --exclude-subdir; \
# install Rust nightly, default is stable
	rustup install nightly; \
# install cargo tools
	cargo install \
		cargo-audit cargo-web wasm-pack; \
	cargo install sccache --features redis; \
# install wasm toolchain
	rustup target add wasm32-unknown-unknown; \
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc; \
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

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
