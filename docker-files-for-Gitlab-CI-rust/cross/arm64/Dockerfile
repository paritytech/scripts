# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier

# temporary support of 16.04 with its Clib
FROM parity/rust-parity-ethereum-build:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="Image for CI build stage for Parity Ethereum arm64 binary." \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/cross/arm64"

# install aarch64(armv8) dependencies and tools
RUN set -eux; \
	dpkg --add-architecture arm64; \
	echo '# source urls for arm64 \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
		# end arm64 section' >> /etc/apt/sources.list;\
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
	cp /tmp/sources-tmp.list /etc/apt/sources.list; \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
	cat /etc/apt/sources.list; \
	cp /tmp/sources-tmp.list /etc/apt/sources.list; \
	echo "next"; \
	cat /etc/apt/sources.list; \
# install dependencies
	apt-get -y update; \
	apt-get install -y \
		g++-aarch64-linux-gnu gcc-aarch64-linux-gnu \
		libudev-dev libudev-dev:arm64; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install aarch64 toolchain
	rustup target add aarch64-unknown-linux-gnu

# set cross-compiler ENV
COPY config /.cargo/config
ENV CC=aarch64-linux-gnu-gcc \
	CXX=aarch64-linux-gnu-g++ \
	CARGO_TARGET=aarch64-unknown-linux-gnu \
	HOST_CC=gcc \
	HOST_CXX=g++ \
	LDFLAGS="-L/usr/lib/arm-linux-aarch64" \
	CPPFLAGS="-I/usr/include" \
# cache handler
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/parity-ethereum/cargo \
	SCCACHE_DIR=/ci-cache/parity-ethereum/sccache \
# show backtraces
	RUST_BACKTRACE=1
