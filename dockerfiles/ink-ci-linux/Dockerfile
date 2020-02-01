FROM registry.parity.io/parity/infrastructure/scripts/base-ci-linux:latest

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/ink-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
libelf-dev libdw-dev zlib1g-dev; kcov; rust nightly-2019-08-30 clippy rustfmt cargo-kcov" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# install specific Rust nightly toolchain
# see on https://rust-lang.github.io/rustup-components-history/
RUN	rustup default nightly-2020-02-01; \
# install wasm32 target for this toolchain
    rustup target add wasm32-unknown-unknown; \
# install cargo tools
    rustup component add rustfmt clippy; \
	cargo install sccache --features redis; \
	cargo install grcov; \
	cargo install --git https://github.com/paritytech/cargo-contract; \
# versions
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
	rm -rf /var/lib/apt/lists/*;

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handler
	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
