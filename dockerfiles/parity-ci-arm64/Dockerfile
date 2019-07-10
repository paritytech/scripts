FROM parity/parity-ci-linux:latest as builder

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/parity-ci-arm64" \
	io.parity.image.description="g++-aarch64-linux-gnu gcc-aarch64-linux-gnu libudev-dev \
libudev-dev:arm64; rustup target aarch64-unknown-linux-gnu" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-arm64/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-arm64/README.md" \
	io.parity.image.revision=${VCS_REF} \
	io.parity.image.created=${BUILD_DATE}

# install aarch64(armv8) dependencies and tools
RUN set -eux; \
	dpkg --add-architecture arm64; \
	echo '# source urls for arm64 \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
		deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
		deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \
		\n # end arm64 section' >> /etc/apt/sources.list; \
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
	cp /tmp/sources-tmp.list /etc/apt/sources.list; \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list; \
	cp /tmp/sources-tmp.list /etc/apt/sources.list; \
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
ENV CC=aarch64-linux-gnu-gcc \
	CXX=aarch64-linux-gnu-g++ \
	CARGO_TARGET=aarch64-unknown-linux-gnu \
	HOST_CC=gcc \
	HOST_CXX=g++ \
	LDFLAGS="-L/usr/lib/arm-linux-aarch64" \
	CPPFLAGS="-I/usr/include" \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
