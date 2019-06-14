FROM parity-ci-linux:latest as builder

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/parity-ci-i386" \
	io.parity.image.description="gcc-multilib g++-multilib libudev-dev libudev-dev:i386; \
cargo target i686-unknown-linux-gnu" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
docker-files-for-Gitlab-CI-rust/cross/i686/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
docker-files-for-Gitlab-CI-rust/cross/i686/README.md" \
	io.parity.image.revision=${VCS_REF} \
	io.parity.image.created=${BUILD_DATE}

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
# show backtraces
	RUST_BACKTRACE=1
