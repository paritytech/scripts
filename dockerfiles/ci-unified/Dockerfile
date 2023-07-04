FROM docker.io/library/debian:bullseye-20230522-slim


### meta ###

ARG DISTRO_CODENAME="bullseye"
ARG RUST_STABLE_VERSION="1.69.0"
ARG RUST_NIGHTLY_VERSION="2023-05-23"
ARG LLVM_VERSION="15"
ARG MINIO_VERSION="2023-04-06T16-51-10Z"

WORKDIR /builds

ENV SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    CC=clang-${LLVM_VERSION} \
    CXX=clang-${LLVM_VERSION} \
    RUST_BACKTRACE=1


### base ###


# base | add non-root user
RUN groupadd -g 1000 nonroot && \
    useradd -u 1000 -g 1000 -s /bin/bash -m nonroot

# base | customize cargo configuration
COPY ci-unified/cargo-config /root/.cargo/config
COPY ci-unified/cargo-config /home/nonroot/.cargo/config

# base | replace REPLACEME in the cargo configs with the real llvm version
RUN sed -i "s/REPLACEME/${LLVM_VERSION}/g" /root/.cargo/config && \
    sed -i "s/REPLACEME/${LLVM_VERSION}/g" /home/nonroot/.cargo/config

# base | install tools and dependencies
RUN set -eux; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        libssl-dev make cmake graphviz \
        git pkg-config curl wget time rhash ca-certificates jq \
        python3 python3-pip lsof ruby ruby-bundler git-restore-mtime \
        xz-utils zstd unzip gnupg protobuf-compiler

# base | add llvm repo, clang and dependencies
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc && \
    echo "deb http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    echo "deb-src http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        clang-${LLVM_VERSION} lldb-${LLVM_VERSION} lld-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev

# base | install specific minio client version (2023-04-06)
RUN curl -L "https://dl.min.io/client/mc/release/linux-amd64/archive/mc.${MINIO_VERSION}" -o /usr/local/bin/mc && \
    chmod 755 /usr/local/bin/mc

# base | set a link to clang
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${LLVM_VERSION} 100

# base | set a link to ldd
RUN update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld-${LLVM_VERSION} 100

# base | install rustup, use minimum components
RUN curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
         -o rustup-init && \
    chmod u+x rustup-init && \
    ./rustup-init -y --no-modify-path --default-toolchain none && \
    rm -f rustup-init && \
    chown -R root:nonroot ${RUSTUP_HOME} ${CARGO_HOME} && \
    chmod -R g+w ${RUSTUP_HOME} ${CARGO_HOME}

# base | install python tools
RUN pip install yq


### generic ci ####


# generic ci | install stable rust
RUN rustup toolchain install "${RUST_STABLE_VERSION}" --profile minimal && \
    rustup default "${RUST_STABLE_VERSION}"

# generic ci | "alias" pinned stable toolchain as generic stable
RUN ln -s "/usr/local/rustup/toolchains/${RUST_STABLE_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/stable-x86_64-unknown-linux-gnu

# generic ci | install additional rustup components for the ci tests
RUN rustup component add rust-src rustfmt clippy

# generic ci | install specific rust nightly, default is stable, use minimum components
RUN rustup toolchain install "nightly-${RUST_NIGHTLY_VERSION}" --profile minimal --component rustfmt

# generic ci | "alias" pinned nightly toolchain as generic nightly
RUN ln -s "/usr/local/rustup/toolchains/nightly-${RUST_NIGHTLY_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu

# generic ci | install wasm toolchain for the default stable toolchain
RUN rustup target add wasm32-unknown-unknown

# generic ci | install cargo tools
RUN cargo install cargo-web wasm-pack cargo-deny cargo-spellcheck cargo-hack \
                  mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed && \
    cargo install cargo-nextest --locked

# generic ci | diener 0.4.6 | NOTE: before upgrading please test new version with companion build, example can be found here: https://github.com/paritytech/substrate/pull/12710
RUN cargo install diener --version 0.4.6

# generic ci | wasm-bindgen-cli version should match the one pinned in substrate
RUN cargo install --version 0.2.73 wasm-bindgen-cli

# generic ci | install wasm-gc. useful for stripping slimming down wasm binaries
RUN cargo install wasm-gc

# generic ci | install cargo hfuzz and honggfuzz dependencies
RUN apt-get -y update && \
    apt-get install -y binutils-dev libunwind-dev libblocksruntime-dev && \
    cargo install honggfuzz


### contracts ci ####


RUN apt-get install -y --no-install-recommends \
        zlib1g-dev npm wabt && \
	npm install --ignore-scripts -g yarn 

# contracts ci 
# `binaryen` is needed by `cargo-contract` for optimizing Wasm files.
# We fetch the latest release which contains a Linux binary.
RUN	curl -L $(curl --silent https://api.github.com/repos/WebAssembly/binaryen/releases \
		 | jq -r '.[0].assets | [.[] | .browser_download_url] | map(select(match("x86_64-linux\\.tar\\.gz$"))) | .[0]' \
		 ) | tar -xz -C /usr/local/bin/ --wildcards --strip-components=2 'binaryen-*/bin/wasm-opt'

# contracts ci 
# We also use the nightly toolchain for linting. We perform checks using RustFmt, and
# Cargo Clippy.
#
# Note that we pin the nightly toolchain since it often creates breaking changes during
# the RustFmt and Clippy stages of the CI.
RUN rustup target add wasm32-unknown-unknown \
    --toolchain "nightly-${RUST_NIGHTLY_VERSION}"
RUN rustup component add rustfmt clippy rust-src \
    --toolchain "nightly-${RUST_NIGHTLY_VERSION}"

# contracts ci 
# `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
RUN	cargo install cargo-dylint dylint-link

# contracts ci 
# Install the latest `cargo-contract`
RUN	cargo install --git https://github.com/paritytech/cargo-contract \
        --locked --branch master --force

# contracts ci 
# Download the latest `substrate-contracts-node` binary
RUN	curl -L -o substrate-contracts-node.zip 'https://gitlab.parity.io/parity/mirrors/substrate-contracts-node/-/jobs/artifacts/main/download?job=build-linux' && \
	unzip substrate-contracts-node.zip && \
	mv artifacts/substrate-contracts-node-linux/substrate-contracts-node /usr/local/cargo/bin/substrate-contracts-node && \
	rm -r artifacts substrate-contracts-node.zip && \
	chmod +x /usr/local/cargo/bin/substrate-contracts-node

# contracts ci 
# We use `estuary` as a lightweight cargo registry in the CI to test if
# publishing `cargo-contract` to it and installing it from there works.
RUN	cargo install --git https://github.com/onelson/estuary.git --force


### bridges-ci ####
### CI image with all dependencies for parity-bridges-common compilation.

### covered by generic-ci + contracts-ci


### finalize ###


# finalize | versions
RUN rustup show && \
    cargo --version && \
    #contracts-ci
    yarn --version && \
    echo $( substrate-contracts-node --version | awk 'NF' ) && \
	estuary --version

# finalize | cargo clean up, removes compilation artifacts cargo install creates (>250M)
RUN rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache

# finalize | apt clean up
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
