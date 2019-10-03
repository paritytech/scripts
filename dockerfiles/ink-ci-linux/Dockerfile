FROM parity/rust-builder:latest

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/ink-ci-linux" \
	io.parity.image.description="inherits from rust-builder; libcurl4-openssl-dev python3 \
libelf-dev libdw-dev zlib1g-dev; kcov; rust nightly-2019-08-30 clippy rustfmt cargo-kcov" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# install tools and dependencies
RUN set -eux; \
	DEBIAN_FRONTEND=noninteractive apt-get -y update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
# dependencies for kcov
		libcurl4-openssl-dev libelf-dev libdw-dev zlib1g-dev python3; \
# kcov building
	curl -L https://github.com/SimonKagstrom/kcov/archive/v36.tar.gz | tar xvz; \
	mkdir -p kcov-v36/build; \
	cd kcov-v36/build/; \
	cmake ..; \
	make; \
	make install; \
	kcov --version; \
# clean up
	cd /builds; \
	rm -rf ./kcov-v36; \
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# install specific Rust nightly toolchain
	rustup default nightly-2019-10-03; \
# reinstall wasm32 target for this toolchain
    rustup target add wasm32-unknown-unknown; \
# install cargo tools
    rustup component add \
		clippy rustfmt; \
	cargo install cargo-kcov; \
# versions
	rustup show; \
	cargo --version
