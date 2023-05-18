FROM docker.io/library/ubuntu:jammy-20230425


### meta ###

ARG DISTRO_CODENAME="jammy"
ARG RUST_STABLE_VERSION="1.69.0"
ARG RUST_NIGHTLY_VERSION="2022-11-16"
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

# base | install tools and dependencies
RUN set -eux; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        libssl-dev make cmake graphviz \
        git pkg-config curl wget time rhash ca-certificates jq \
        python3 python3-pip lsof ruby ruby-bundler git-restore-mtime \
        xz-utils zstd unzip gnupg protobuf-compiler && \

# base | add llvm repo, clang and dependencies
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc && \
    echo "deb http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    echo "deb-src http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        clang-${LLVM_VERSION} lldb-${LLVM_VERSION} lld-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev && \

# base | replace REPLACEME in the cargo configs with the real llvm version
    sed -i "s/REPLACEME/${LLVM_VERSION}/g" /root/.cargo/config && \
    sed -i "s/REPLACEME/${LLVM_VERSION}/g" /home/nonroot/.cargo/config && \

# base | install specific minio client version (2023-04-06)
    curl -L "https://dl.min.io/client/mc/release/linux-amd64/archive/mc.${MINIO_VERSION}" -o /usr/local/bin/mc && \
    chmod 755 /usr/local/bin/mc && \

# base | set a link to clang
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${LLVM_VERSION} 100 && \

# base | set a link to ldd
    update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld-${LLVM_VERSION} 100 && \

# base | install rustup, use minimum components
    curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
         -o rustup-init && \
    chmod u+x rustup-init && \
    ./rustup-init -y --no-modify-path --default-toolchain none && \
    rm -f rustup-init && \
    chown -R root:nonroot ${RUSTUP_HOME} ${CARGO_HOME} && \
    chmod -R g+w ${RUSTUP_HOME} ${CARGO_HOME} && \

# base | install python tools
    pip install yq


### generic ci ####


# generic ci | install stable rust
RUN set -eux && \
    rustup toolchain install "${RUST_STABLE_VERSION}" --profile minimal && \
    rustup default "${RUST_STABLE_VERSION}" && \

# generic ci | "alias" pinned stable toolchain as generic stable
    ln -s "/usr/local/rustup/toolchains/${RUST_STABLE_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/stable-x86_64-unknown-linux-gnu && \

# generic ci | install additional rustup components for the ci tests
    rustup component add rust-src rustfmt clippy && \

# generic ci | install specific rust nightly, default is stable, use minimum components
    rustup toolchain install "nightly-${RUST_NIGHTLY_VERSION}" --profile minimal --component rustfmt && \

# generic ci | "alias" pinned nightly toolchain as generic nightly
    ln -s "/usr/local/rustup/toolchains/nightly-${RUST_NIGHTLY_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \

# generic ci | install wasm toolchain for the default stable toolchain
    rustup target add wasm32-unknown-unknown && \

# generic ci | install cargo tools
    cargo install cargo-web wasm-pack cargo-deny cargo-spellcheck cargo-hack \
                  mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed && \
    cargo install cargo-nextest --locked && \

# generic ci | diener 0.4.6 | NOTE: before upgrading please test new version with companion build, example can be found here: https://github.com/paritytech/substrate/pull/12710
    cargo install diener --version 0.4.6 && \

# generic ci | wasm-bindgen-cli version should match the one pinned in substrate
    cargo install --version 0.2.73 wasm-bindgen-cli && \

# generic ci | install wasm-gc. useful for stripping slimming down wasm binaries
    cargo install wasm-gc && \

# generic ci | install cargo hfuzz and honggfuzz dependencies
    apt-get -y update && \
    apt-get install -y binutils-dev libunwind-dev libblocksruntime-dev && \
    cargo install honggfuzz


### finalize ###


# finalize | versions
RUN rustup show && \
    cargo --version && \

# finalize | cargo clean up, removes compilation artifacts cargo install creates (>250M)
    rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \

# finalize | apt clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
