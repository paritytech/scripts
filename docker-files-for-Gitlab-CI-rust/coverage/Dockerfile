# triggers image autoupdate with the new Rust release
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim as notifier

# temporary support of 16.04 with its Clib
FROM ubuntu:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-coverage" \
	description="Image for CI to collects and aggregates code coverage information for Rust projects. Based on grcov https://github.com/mozilla/grcov" \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/coverage"

WORKDIR /builds/

# rustup directory
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
# install tools and dependencies
RUN apt-get -y update; \
    apt-get install -y --no-install-recommends \
		software-properties-common curl git \
		make cmake ca-certificates g++  \
		gcc pkg-config libudev-dev time \
		libssl-dev libc6-dev wget; \
# install LLVM
    LLVM_REPO="deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main \n \
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main \n \
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main \n \
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main "; \
    echo "$LLVM_REPO" > /etc/apt/sources.list.d/llvm.list; \
    cat /etc/apt/sources.list.d/llvm.list; \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -;\
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
    libllvm8 llvm-8 llvm-8-dev llvm-8-runtime; \
# libssl-dev won't be needed in rust:stretch
# install rustup
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
	  cargo install grcov; \
# apt clean up
    apt-get remove -y --auto-remove wget; \
	  rm -rf /var/lib/apt/lists/*

# show backtraces
ENV RUST_BACKTRACE=1
