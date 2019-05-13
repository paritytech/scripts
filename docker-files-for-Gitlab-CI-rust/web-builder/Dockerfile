FROM rust:slim

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-builder" \
	io.parity.image.description="curl gcc make libssl-dev pkg-config clang-8. \
        Rust stable, nightly; cargo-web wasm-pack." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/web-builder/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/master/docker-files-for-Gitlab-CI-rust/web-builder/README.md"

# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 8 has WASM support enabled by default.
RUN set -eux; \
    echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" > /etc/apt/sources.list.d/llvm.list; \
    echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" >> /etc/apt/sources.list.d/llvm.list; \
    apt-get update; \
    apt-get install -y --allow-unauthenticated \
        curl gcc make libssl-dev pkg-config clang-8; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# set a link to clang-8
    ln -s /usr/bin/clang-8 /usr/bin/clang; \
# install rust nightly and wasm toolchain
    rustup target add wasm32-unknown-unknown; \
    rustup toolchain install nightly; \
    rustup target add --toolchain nightly wasm32-unknown-unknown; \
# install cargo tools
    cargo install cargo-web; \
    cargo install wasm-pack;

# show backtraces
ENV RUST_BACKTRACE=1

COPY config /root/.cargo