FROM ubuntu:xenial as builder

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-coverage" \
	io.parity.image.description="software-properties-common curl git make cmake \
ca-certificates g++  gcc pkg-config libudev-dev time libssl-dev libc6-dev wget; \
libllvm9 llvm-9 llvm-9-dev llvm-9-runtime; rust grcov" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-coverage/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-coverage/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

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
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main \n \
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main "; \
    echo "$LLVM_REPO" > /etc/apt/sources.list.d/llvm.list; \
    cat /etc/apt/sources.list.d/llvm.list; \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -;\
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        libllvm9 llvm-9 llvm-9-dev llvm-9-runtime; \
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
