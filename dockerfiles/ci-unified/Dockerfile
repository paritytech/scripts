FROM docker.io/library/debian:bullseye-20230522-slim


### meta ###
# Static vars, dynamic vars can be found in the build-args file. Variables were moved for caching.
ENV RESTIC_VERSION="0.16.1" \
    LLVM_VERSION="15" \
    MINIO_VERSION="2023-04-06T16-51-10Z" \
    RUSTC_RV32E_TOOLCHAIN_TAG="v1.1.0" \
    RUSTC_RV32E_TOOLCHAIN_VERSION="nightly-2024-01-05"

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
    bzip2 xz-utils zstd unzip gnupg protobuf-compiler

# base | add llvm repo, clang and dependencies
ARG DISTRO_CODENAME="bullseye"
RUN echo ${DISTRO_CODENAME} ${LLVM_VERSION}
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc && \
    echo "deb http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    echo "deb-src http://apt.llvm.org/${DISTRO_CODENAME}/ llvm-toolchain-${DISTRO_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm-toochain-${DISTRO_CODENAME}-${LLVM_VERSION}.list; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
    clang-${LLVM_VERSION} lldb-${LLVM_VERSION} lld-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev

# base | install specific minio client version
RUN curl -L "https://dl.min.io/client/mc/release/linux-amd64/archive/mc.${MINIO_VERSION}" -o /usr/local/bin/mc && \
    chmod 755 /usr/local/bin/mc

# base | install restic
RUN wget https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 -O- | bzcat > /usr/local/bin/restic \
    && chmod 755 /usr/local/bin/restic

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

# base | install yq via pip
RUN pip install yq


### generic ci ####

ARG GH_TOOL_VERSION="2.54.0"

RUN wget "https://github.com/cli/cli/releases/download/v${GH_TOOL_VERSION}/gh_${GH_TOOL_VERSION}_linux_amd64.deb" && \
    dpkg -i "gh_${GH_TOOL_VERSION}_linux_amd64.deb"

ARG RUST_STABLE_VERSION="1.81.0"

# generic ci | install stable rust
RUN rustup toolchain install "${RUST_STABLE_VERSION}" --profile minimal && \
    rustup default "${RUST_STABLE_VERSION}"

# generic ci | "alias" pinned stable toolchain as generic stable
RUN ln -s "/usr/local/rustup/toolchains/${RUST_STABLE_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/stable-x86_64-unknown-linux-gnu

# generic ci | install additional rustup components for the ci tests
RUN rustup component add rust-src rustfmt clippy

ARG RUST_NIGHTLY_VERSION="2024-09-11"

# generic ci | install specific rust nightly, default is stable, use minimum components
RUN rustup toolchain install "nightly-${RUST_NIGHTLY_VERSION}" --profile minimal --component rustfmt rust-analyzer

# generic ci | "alias" pinned nightly toolchain as generic nightly
RUN ln -s "/usr/local/rustup/toolchains/nightly-${RUST_NIGHTLY_VERSION}-x86_64-unknown-linux-gnu" /usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu

# generic ci | install wasm toolchain for the default stable toolchain
RUN rustup target add wasm32-unknown-unknown

# generic ci | install x86_64 musl toolchain for the default stable toolchain
RUN apt-get install -y --no-install-recommends g++
RUN rustup target add x86_64-unknown-linux-musl

# generic ci | install common cargo tools
RUN cargo install cargo-web wasm-pack cargo-deny cargo-hack \
    mdbook mdbook-mermaid mdbook-linkcheck mdbook-admonish mdbook-last-changed

RUN cargo install mdbook-graphviz --locked

RUN cargo install cargo-spellcheck cargo-nextest --locked

# generic ci | diener 0.4.6 | NOTE: before upgrading please test new version with companion build, example can be found here: https://github.com/paritytech/substrate/pull/12710
RUN cargo install diener --version 0.4.6

# generic ci | wasm-bindgen-cli version should match the one pinned in substrate
RUN cargo install wasm-bindgen-cli --version 0.2.73

# generic ci | install taplo
RUN cargo install taplo-cli --locked --version 0.8.1

# generic ci | install zepter
RUN cargo install zepter --locked --version 0.15.0

# generic ci | install wasm-gc. useful for stripping slimming down wasm binaries
RUN cargo install wasm-gc

# generic ci | install cargo-edit. Manipilation of Cargo.tomls (like bumping versions) in CI
RUN cargo install cargo-edit

# generic ci | install cargo hfuzz and honggfuzz dependencies
RUN apt-get -y update && \
    apt-get install -y binutils-dev libunwind-dev libblocksruntime-dev && \
    cargo install honggfuzz@0.5.55


### contracts ci ####


RUN apt-get install -y --no-install-recommends \
    zlib1g-dev npm wabt && \
    npm install --ignore-scripts -g yarn

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
RUN cargo install subkey

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
RUN	cargo install --git https://github.com/onelson/estuary.git --force --locked


### bridges-ci ###
### CI image with all dependencies for parity-bridges-common compilation.


### covered by generic-ci + contracts-ci


### ink-ci-linux ###


# ink-ci-linux
# Needed for running commands in parallel, without overlapping output.
# gnupg is only needed to verify the signature of the codecov uploader.
RUN	apt-get install -y --no-install-recommends parallel

# ink-ci-linux
# We also use the nightly toolchain to lint ink!. We perform checks using RustFmt,
# Cargo Clippy, and Miri.
#
# Note that we pin the nightly toolchain since it often creates breaking changes during
# the RustFmt and Clippy stages of the CI.
RUN rustup component add \
    miri rustc-dev llvm-tools-preview \
    --toolchain "nightly-${RUST_NIGHTLY_VERSION}"

# ink-ci-linux
# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
# We require `xargo` so that `miri` runs properly
RUN	cargo install grcov rust-covfix xargo


### ink-waterfall-ci ###


RUN	apt-get install -y --no-install-recommends \
    # ink-waterfall-ci
    # `redis-cli` is needed to interact with ci/cd's redis
    redis-tools \
    # ink-waterfall-ci
    # `firefox` is needed to simulate interactions with the `canvas-ui`
    firefox-esr

# ink-waterfall-ci
# `geckodriver` is needed to run headless browser tests
# we fetch the latest version number from the github api and use that release
RUN	curl --silent https://api.github.com/repos/mozilla/geckodriver/releases/latest | \
    egrep --only-matching 'https://github.com/mozilla/geckodriver/releases/download/v[0-9.]+/geckodriver-v[0-9.]+-linux64.tar.gz' | \
    head -n1 | \
    xargs curl -L -O && \
    tar -xvzf geckodriver-v*-linux64.tar.gz && \
    rm geckodriver-v*-linux64.tar.gz && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/

# ink-waterfall-ci
# We additionally install the `substrate-contracts-node` as `substrate-contracts-rand-extension`.
# This installation though is a modified `substrate-contracts-node`, so that ink!'s
# `rand-extension` chain extension example is included in the runtime.
# This enables us to test in the waterfall that the `rand-extension`
# integration with Substrate still works.
# TODO: address https://github.com/paritytech/scripts/issues/604 and re-enable
# RUN	git clone --depth 1 https://github.com/paritytech/substrate-contracts-node.git && \
# 	curl -s https://raw.githubusercontent.com/paritytech/ink/master/integration-tests/rand-extension/runtime/chain-extension-example.rs \
# 		>> substrate-contracts-node/runtime/src/lib.rs && \
# 	sed -i 's/type ChainExtension = ();/type ChainExtension = FetchRandomExtension;/g' substrate-contracts-node/runtime/src/lib.rs && \
# 	sed -i 's/name = "substrate-contracts-node"/name = "substrate-contracts-node-rand-extension"/g' substrate-contracts-node/node/Cargo.toml && \
# 	cargo install --locked --path substrate-contracts-node/node/

# ink-waterfall-ci
# Needed for regression testing, a CSV contains the sizes of compiled contracts.
RUN	cargo install --git https://github.com/paritytech/ink-waterfall.git csv-comparator && \
    npm install -g csv2md


### parity-scale-codec ###

# codecov from ink-ci-linux

# parity-scale-codec
RUN	cargo +nightly-${RUST_NIGHTLY_VERSION} install grcov rust-covfix xargo dylint-link


# install rustc-rv32e-toolchain
RUN wget -q https://github.com/paritytech/rustc-rv32e-toolchain/releases/download/${RUSTC_RV32E_TOOLCHAIN_TAG}/rust-rve-${RUSTC_RV32E_TOOLCHAIN_VERSION}-x86_64-unknown-linux-gnu.tar.zst && \
    tar --zstd -xf rust-rve-${RUSTC_RV32E_TOOLCHAIN_VERSION}-x86_64-unknown-linux-gnu.tar.zst && \
    mv rve-nightly /usr/local/rustup/toolchains && \
    rm -f rust-rve-${RUSTC_RV32E_TOOLCHAIN_VERSION}-x86_64-unknown-linux-gnu.tar.zst


### forklift


# forklift | install forklift
COPY ci-unified/download-forklift.sh download-forklift.sh
RUN chmod +x download-forklift.sh

ARG FORKLIFT_VERSION="0.13.2"

RUN bash download-forklift.sh -v ${FORKLIFT_VERSION} -p ./forklift/


### codecov


RUN curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --import

# codecov uploader
ARG CODECOV_UPLOADER_VERSION="v0.7.3"

RUN	curl --remote-name --silent https://uploader.codecov.io/${CODECOV_UPLOADER_VERSION}/linux/codecov && \
    curl --remote-name --silent https://uploader.codecov.io/${CODECOV_UPLOADER_VERSION}/linux/codecov.SHA256SUM && \
    curl --remote-name --silent https://uploader.codecov.io/${CODECOV_UPLOADER_VERSION}/linux/codecov.SHA256SUM.sig && \
    gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
    shasum --algorithm 256 --check codecov.SHA256SUM && \
    chmod +x codecov && \
    mv codecov /usr/local/bin/codecov && \
    rm -f codecov.SHA256SUM codecov.SHA256SUM.sig

#codecov-cli
ARG CODECOV_CLI_VERSION="v0.6.0"

RUN curl -Os https://cli.codecov.io/${CODECOV_CLI_VERSION}/linux/codecov && \
    curl -Os https://cli.codecov.io/${CODECOV_CLI_VERSION}/linux/codecov.SHA256SUM && \
    curl -Os https://cli.codecov.io/${CODECOV_CLI_VERSION}/linux/codecov.SHA256SUM.sig && \
    gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
    shasum -a 256 -c codecov.SHA256SUM && \
    chmod +x codecov && \
    mv codecov /usr/local/bin/codecovcli && \
    rm -f codecov.SHA256SUM codecov.SHA256SUM.sig

### finalize ###


# finalize | versions
RUN rustup show && \
    cargo --version && \
    #contracts-ci
    yarn --version && \
    echo $( substrate-contracts-node --version | awk 'NF' ) && \
    estuary --version && \
    # inc-ci-linux
    cargo-contract --version
# ink-waterfall-ci
# substrate-contracts-node-rand-extension --version
RUN forklift version

# finalize | cargo clean up, removes compilation artifacts cargo install creates (>250M)
RUN rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache

# finalize | apt clean up
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
