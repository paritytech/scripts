FROM ubuntu:xenial

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/parity-ci-linux" \
	io.parity.image.description="curl git make cmake ca-certificates rhash \
pkg-config libudev-dev time libssl-dev libc6-dev clang-9 lld-9 libclang-9-dev \
rust stable/beta/nightly, cargo-audit, sccache" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds
# config for clang
COPY utility/parity-ci-linux-config /.cargo/config
# rustup directory and compiler ENV
#RUSTFLAGS Linker-plugin-LTO https://doc.rust-lang.org/rustc/linker-plugin-lto.html
#RUSTDOCFLAGS issue https://github.com/rust-lang/cargo/issues/7529
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
	RUSTFLAGS="-C linker-plugin-lto -C linker=clang -C link-arg=-fuse-ld=lld" \
	RUSTDOCFLAGS="-C linker-plugin-lto -C linker=clang -C link-arg=-fuse-ld=lld" \
    CC=clang \
	CXX=clang


# download rustup
ADD "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" rustup-init

# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 9 has WASM support enabled by default.
COPY utility/debian-llvm-clang.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg

# install tools and dependencies
RUN set -eux; \
	echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
# libssl-dev is needed for cargo-audit and sccache
		clang-9 lld-9 libclang-9-dev \
		make cmake libudev-dev ca-certificates \
		git libssl-dev pkg-config curl time rhash; \
# set a link to clang-9
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 100; \
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang-9 100; \
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
# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
