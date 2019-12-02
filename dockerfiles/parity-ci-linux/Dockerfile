FROM ubuntu:xenial as builder

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
# install tools and dependencies
COPY clang9.key /etc/apt/trusted.gpg.d/debian-archive-jessie-automatic.gpg
RUN set -eux; \
	echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
# libssl-dev is needed for cargo-audit and sccache
		g++ libssl-dev gcc clang-9 libclang-9-dev \
		make cmake libudev-dev ca-certificates \
		git pkg-config curl time rhash; \
# set a link to clang-9
	ln -s /usr/bin/clang-9 /usr/bin/clang; \
# install rustup
	chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain stable; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
	rustup install nightly beta; \
	cargo install cargo-audit; \
	cargo install sccache --features redis; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf $CARGO_HOME/registry; \
# removes toolchain's html docs and autocompletions (>300M for each toolchain)
	rm -rf /usr/local/rustup/toolchains/*/share; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
