# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier

# temporary support of 16.04 with its Clib
FROM parity/rust-parity-ethereum-build:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="Image for CI build stage for Parity Ethereum i386 binary." \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/cross/i686"

# install i386 dependencies and tools
RUN set -eux; \
	dpkg --add-architecture i386; \
# install dependencies
	apt-get -y update; \
	apt install -y \
		gcc-multilib g++-multilib \
		libudev-dev libudev-dev:i386; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install i686 toolchain
	rustup target add i686-unknown-linux-gnu

# set cross-compiler ENV
ENV CC=gcc \
	CXX=g++ \
	CARGO_TARGET=i686-unknown-linux-gnu \
	HOST_CC=gcc \
	HOST_CXX=g++ \
	LDFLAGS="-L/usr/lib32" \
	CPPFLAGS="-I/usr/include" \
# cache handler
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/parity-ethereum/cargo \
	SCCACHE_DIR=/ci-cache/parity-ethereum/sccache \
# show backtraces
	RUST_BACKTRACE=1
