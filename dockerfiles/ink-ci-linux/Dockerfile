ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

ARG RUST_NIGHTLY="2023-03-21"

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-ci-linux" \
	io.parity.image.description="Inherits from docker.io/paritytech/base-ci-linux. \
rust nightly, clippy, rustfmt, miri, rust-src, rustc-dev, grcov, rust-covfix, \
llvm-tools-preview, cargo-contract, xargo, binaryen, parallel, codecov" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

RUN set -eux; \
	apt-get -y update && \

	# Needed for running commands in parallel, without overlapping output.
	# gnupg is only needed to verify the signature of the codecov uploader.
	apt-get install -y --no-install-recommends parallel gnupg && \

	# codecov uploader
	curl --remote-name --silent https://uploader.codecov.io/latest/linux/codecov && \
	curl --remote-name --silent https://uploader.codecov.io/latest/linux/codecov.SHA256SUM && \
	curl --remote-name --silent https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig && \
	curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --import && \
	gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
	shasum --algorithm 256 --check codecov.SHA256SUM && \
	chmod +x codecov && \
	mv codecov /usr/local/bin/codecov && \
	rm -f codecov.SHA256SUM codecov.SHA256SUM.sig && \

	# `binaryen` is needed by `cargo-contract` for optimizing Wasm files.
	# We fetch the latest release which contains a Linux binary.
	curl -L $(curl --silent https://api.github.com/repos/WebAssembly/binaryen/releases \
		 | jq -r '.[0].assets | [.[] | .browser_download_url] | map(select(match("x86_64-linux\\.tar\\.gz$"))) | .[0]' \
		 ) | tar -xz -C /usr/local/bin/ --wildcards --strip-components=2 'binaryen-*/bin/wasm-opt' && \

	# The stable toolchain is used to build ink! itself through the use of the
	# `RUSTC_BOOSTRAP=1` environment variable. We also need to install the
	# `wasm32-unknown-unknown` target since that's the platform that ink! smart contracts
	# run on.
	#
	# The 1.69 toolchain is temporarily required to build ink! contracts because of
	# https://github.com/paritytech/cargo-contract/issues/1139
	rustup target add wasm32-unknown-unknown --toolchain 1.69 && \
	rustup component add rust-src clippy rustfmt --toolchain 1.69 && \
	rustup default 1.69 && \

	# We also use the nightly toolchain to lint ink!. We perform checks using RustFmt,
	# Cargo Clippy, and Miri.
	#
	# Note that we pin the nightly toolchain since it often creates breaking changes during
	# the RustFmt and Clippy stages of the CI.
	rustup toolchain install nightly-${RUST_NIGHTLY} --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy miri rust-src rustc-dev llvm-tools-preview && \

	# Alias pinned toolchain as nightly, otherwise it appears as though we
	# don't have a nightly toolchain (i.e rustc +nightly --version is empty)
	ln -s /usr/local/rustup/toolchains/nightly-${RUST_NIGHTLY}-x86_64-unknown-linux-gnu \
		/usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \

	# `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
	cargo install cargo-dylint dylint-link && \

	# Install the latest `cargo-contract`
	cargo install --git https://github.com/paritytech/cargo-contract \
        --locked --branch master --force && \

    # Download the latest `substrate-contracts-node` binary
	curl -L -o substrate-contracts-node.zip 'https://gitlab.parity.io/parity/mirrors/substrate-contracts-node/-/jobs/artifacts/main/download?job=build-linux' && \
	unzip substrate-contracts-node.zip && \
	mv artifacts/substrate-contracts-node-linux/substrate-contracts-node /usr/local/cargo/bin/substrate-contracts-node && \
	rm -r artifacts substrate-contracts-node.zip && \
	chmod +x /usr/local/cargo/bin/substrate-contracts-node && \


	# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
	# We require `xargo` so that `miri` runs properly
	cargo install grcov rust-covfix xargo && \

	# Automated spell-checking
	cargo install cargo-spellcheck && \

	# More faster test runner for Rust projects than cargo-test 
	cargo install cargo-nextest  && \

	# Versions
	rustup show && \
	cargo --version && \
	cargo-contract --version && \
	wasm-opt --version && \

	# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \

	# apt clean up
	apt-get remove -y gnupg && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# TODO: switch to non-root here when ink-waterfall-ci won't be the dependency of this img
# USER nonroot:nonroot
