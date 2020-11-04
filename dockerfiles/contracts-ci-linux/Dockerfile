ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/contracts-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
zlib1g-dev, npm, yarn, wabt, unzip. \
rust nightly, rustfmt, rust-src" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# copy llvm and yarn repo key
COPY utility/yarn.key /etc/apt/trusted.gpg.d/debian-yarn.gpg

# install tools and dependencies
RUN set -eux; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main"  \
		> /etc/apt/sources.list.d/yarn.list; \
	apt-get -y update; \
	apt-get remove -y --purge clang; \
	apt-get install -y --no-install-recommends \
		npm yarn wabt; \
# Installs the latest common nightly for the listed components,
# adds those components, wasm target and sets the profile to minimal
	rustup toolchain install nightly --target wasm32-unknown-unknown \
			--profile minimal --component rustfmt rust-src; \
	rustup default nightly; \
	cargo install pwasm-utils-cli --bin wasm-prune; \
	cargo install cargo-contract; \
	cargo install --git https://github.com/paritytech/canvas-node --tag v0.1.2; \
# versions
	yarn --version; \
	rustup show; \
	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
