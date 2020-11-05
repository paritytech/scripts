ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/contracts-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
llvm-8-dev, clang-8, npm, yarn, wabt. \
rust nightly, rustfmt, rust-src" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV CXX="/usr/bin/clang++-8"

# copy llvm and yarn repo key
COPY utility/debian-llvm-clang.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg
COPY utility/yarn.key /etc/apt/trusted.gpg.d/debian-yarn.gpg

# install tools and dependencies
RUN set -eux; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main"  \
		> /etc/apt/sources.list.d/yarn.list; \
	echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-8 main" \
		> /etc/apt/sources.list.d/llvm.list; \
	echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-8 main" \
		>> /etc/apt/sources.list.d/llvm.list; \
	apt-get -y update; \
	apt-get remove -y --purge clang; \
	apt-get install -y --no-install-recommends \
		llvm-8-dev clang-8 npm yarn wabt; \
# set a link to clang-8
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100; \
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100; \
	update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 100; \
# Installs the latest common nightly for the listed components,
# adds those components, wasm target and sets the profile to minimal
	rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt rust-src; \
	rustup default nightly; \
	cargo install pwasm-utils-cli --bin wasm-prune; \
	cargo install cargo-contract; \
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
