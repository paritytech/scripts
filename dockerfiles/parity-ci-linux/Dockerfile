FROM ubuntu:xenial

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/parity-ci-linux" \
	io.parity.image.description="curl git make cmake ca-certificates g++ rhash gcc \
pkg-config libudev-dev time libssl-dev libc6-dev clang-9 libclang-9-dev \
rust stable/beta/nightly, cargo-audit, sccache" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# rustup directory
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# download rustup
ADD "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" rustup-init
# download cmake
ADD "https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.sh" cmake.sh
COPY clang9.key /etc/apt/trusted.gpg.d/debian-archive-jessie-automatic.gpg
# install tools and dependencies
RUN set -eux; \
	echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
# libssl-dev is needed for cargo-audit and sccache
		gcc g++ clang-9 libclang-9-dev \
		make libudev-dev ca-certificates \
		git libssl-dev pkg-config curl time rhash; \
# set a link to clang-9
	ln -s /usr/bin/clang-9 /usr/bin/clang; \
# install cmake
  echo "c87dc439a8d6b1b368843c580f0f92770ed641af8ff8fe0b706cfa79eed3ac91 cmake.sh" | sha256sum -c - || exit 1; \
	chmod +x cmake.sh; \
	./cmake.sh --skip-license --prefix=/usr/ --exclude-subdir; \
# install rustup
	chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain stable; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
	rustup install nightly beta; \
	cargo install cargo-audit; \
	cargo install sccache --features redis; \
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
	rm -rf /usr/doc/*; \
	rm cmake.sh

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
