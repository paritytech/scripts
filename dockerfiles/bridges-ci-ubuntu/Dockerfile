# Image with dependencies required to build projects from the bridge repo.
#
# This image is meant to be used as a building block when building images for
# the various components in the bridge repo, such as nodes and relayers.
FROM paritytech/base-ci:latest

RUN rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy miri rust-src && \
	cargo install cargo-deny && \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" && \
# versions
	rustc -vV && \
    cargo -V && \
    gcc -v && \
    g++ -v && \
    cmake --version

# cache handler
ENV	RUSTC_WRAPPER=sccache
# show backtraces
ENV RUST_BACKTRACE=1
