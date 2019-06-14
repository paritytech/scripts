# DockerHub's official https://hub.docker.com/_/rust
FROM rust:slim-stretch

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-builder" \
	io.parity.image.description="g++ libssl-dev gcc clang-8 cmake make git pkg-config \
curl time rhash rust stable, rust nightly, cargo-audit, sccache, wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
docker-files-for-Gitlab-CI-rust/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
docker-files-for-Gitlab-CI-rust/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# install tools and dependencies
COPY clang8.key /etc/apt/trusted.gpg.d/debian-archive-jessie-automatic.gpg
# config for wasm32-unknown-unknown
COPY config /root/.cargo
# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 8 has WASM support enabled by default.
RUN set -eux; \
	echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	DEBIAN_FRONTEND=noninteractive apt-get -y update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		g++ libssl-dev gcc clang-8 cmake make \
		git pkg-config curl time rhash; \
# set a link to clang-8
	ln -s /usr/bin/clang-8 /usr/bin/clang; \
# install Rust nightly, default is stable
	rustup install nightly; \
# install cargo tools
	cargo install \
		cargo-audit sccache cargo-web wasm-pack; \
# install wasm toolchain
	rustup target add wasm32-unknown-unknown; \
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc; \
# versions
	rustup show; \
	cargo --version; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*;

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
