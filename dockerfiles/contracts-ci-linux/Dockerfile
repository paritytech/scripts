FROM registry.parity.io/parity/infrastructure/scripts/base-ci-linux:latest

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/contracts-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. rust nightly" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

COPY utility/debian-llvm-clang.key /etc/apt/trusted.gpg.d/debian-archive-llvm.gpg
# copy yarn repo key
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
		apt-get install -y --no-install-recommends \
		llvm-8-dev clang-8 zlib1g-dev npm yarn wabt unzip; \
# set a link to clang-8
	update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100; \
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100; \
# install wasm toolchain
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install cargo tools
	rustup component add rustfmt; \
	rustup component add rust-src rustfmt --toolchain nightly; \
	cargo install pwasm-utils-cli --bin wasm-prune; \
	cargo install --git https://github.com/paritytech/cargo-contract; \
	cargo install solang; \
# versions
	yarn --version; \
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
	rm -rf /var/lib/apt/lists/*
