ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/contracts-ci-linux" \
	io.parity.image.description="Inherits from base-ci:latest. \
llvm-dev, clang, zlib1g-dev, npm, yarn, wabt, binaryen. \
rust nightly, rustfmt, clippy, rust-src, substrate-contracts-node" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/contracts-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends \
		zlib1g-dev npm wabt llvm-dev && \
	npm install --ignore-scripts -g yarn && \

    # `binaryen` is needed by `cargo-contract` for optimizing Wasm files.
    # We fetch the latest release which contains a Linux binary.
	curl --silent https://api.github.com/repos/WebAssembly/binaryen/releases | \
		egrep --only-matching 'https://github.com/WebAssembly/binaryen/releases/download/version_[0-9]+/binaryen-version_[0-9]+-x86_64-linux.tar.gz' | \
		head -n1 | \
		xargs curl -L -O && \
	tar -xvzf binaryen-*-x86_64-linux.tar.gz  && \
	rm binaryen-*-x86_64-linux.tar.gz && \
	chmod +x binaryen-*/bin/wasm-opt && \
	mv binaryen-*/bin/wasm-opt /usr/local/bin/ && \
	rm -rf binaryen-*/ && \

    # The stable toolchain is used to build ink! contracts through the use of the
    # `RUSTC_BOOSTRAP=1` environment variable. We also need to install the
    # `wasm32-unknown-unknown` target since that's the platform that ink! smart contracts
    # run on.
 	rustup target add wasm32-unknown-unknown --toolchain stable && \
 	rustup component add rust-src --toolchain stable && \
	rustup default stable && \

    # We also use the nightly toolchain for linting. We perform checks using RustFmt, and
    # Cargo Clippy.
    #
    # Note that we pin the nightly toolchain since it often creates breaking changes during
    # the RustFmt and Clippy stages of the CI.
	rustup toolchain install nightly-2022-07-28 --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy rust-src && \

	# Alias pinned toolchain as nightly, otherwise it appears as though we
	# don't have a nightly toolchain (i.e rustc +nightly --version is empty)
	ln -s /usr/local/rustup/toolchains/nightly-2022-07-28-x86_64-unknown-linux-gnu \
 	   	/usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \

    # `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
	cargo install cargo-dylint dylint-link && \

    # Install the latest released version of `cargo-contract`
	cargo install cargo-contract && \

    # Download the latest `substrate-contracts-node` binary
    curl -L -o substrate-contracts-node.zip 'https://gitlab.parity.io/parity/mirrors/substrate-contracts-node/-/jobs/artifacts/main/download?job=build-linux' && \
	unzip substrate-contracts-node.zip && \
	mv artifacts/substrate-contracts-node-linux/substrate-contracts-node /usr/local/cargo/bin/substrate-contracts-node && \
	rm -r artifacts substrate-contracts-node.zip && \
	chmod +x /usr/local/cargo/bin/substrate-contracts-node && \

    # We use `estuary` as a lightweight cargo registry in the CI to test if
    # publishing `cargo-contract` to it and installing it from there works.
	cargo install --git https://github.com/onelson/estuary.git --force && \

    # Versions
	yarn --version && \
	rustup show && \
	cargo --version && \
	echo $( substrate-contracts-node --version | awk 'NF' ) && \
	estuary --version && \

    # cargo clean up
    # removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \

    # apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# TODO: https://gitlab.parity.io/parity/cargo-contract/-/jobs/958744, https://gitlab.parity.io/parity/cargo-contract/-/jobs/958745
# USER nonroot:nonroot
