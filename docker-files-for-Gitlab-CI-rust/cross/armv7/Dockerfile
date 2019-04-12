# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier

# temporary support of 16.04 with its Clib
FROM parity/rust-parity-ethereum-build:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build:armhf" \
	description="Image for CI build stage for Parity Ethereum armhf binary." \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/cross/armhf"

	# install armv7 dependencies and tools
RUN set -eux; \
	dpkg --add-architecture armhf; \
	echo '# source urls for armhf \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
		deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \
		\n # end armhf section' >> /etc/apt/sources.list; \
		sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
		cp /tmp/sources-tmp.list /etc/apt/sources.list; \
		sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
		cp /tmp/sources-tmp.list /etc/apt/sources.list; \
# install dependencies
	apt-get -y update; \
	apt-get install -y \
		g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf \
		libudev-dev libudev-dev:armhf; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install armv7 toolchain
	rustup target add armv7-unknown-linux-gnueabihf

# set cross-compiler ENV
ENV CC=arm-linux-gnueabihf-gcc \
	CXX=arm-linux-gnueabihf-g++ \
	CARGO_TARGET=armv7-unknown-linux-gnueabihf \
	HOST_CC=gcc \
	HOST_CXX=g++ \
	LDFLAGS="-L/usr/lib/arm-linix-gnueabihf" \
	CPPFLAGS="-I/usr/include" \
# cache handler
	RUSTC_WRAPPER=sccache \
	CARGO_HOME=/ci-cache/parity-ethereum/cargo \
	SCCACHE_DIR=/ci-cache/parity-ethereum/sccache \
# show backtraces
	RUST_BACKTRACE=1
