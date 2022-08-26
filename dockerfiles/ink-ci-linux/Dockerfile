ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-ci-linux" \
	io.parity.image.description="Inherits from docker.io/paritytech/base-ci. \
rust nightly, clippy, rustfmt, miri, rust-src, rustc-dev, grcov, rust-covfix, \
llvm-tools-preview, cargo-contract, xargo, binaryen, parallel, codecov" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV CXX=/usr/bin/clang++-10
ENV DEBIAN_FRONTEND=noninteractive

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
	curl --silent https://api.github.com/repos/WebAssembly/binaryen/releases | \
		egrep --only-matching 'https://github.com/WebAssembly/binaryen/releases/download/version_[0-9]+/binaryen-version_[0-9]+-x86_64-linux.tar.gz' | \
		head -n1 | \
		xargs curl -L -O && \
	tar -xvzf binaryen-*-x86_64-linux.tar.gz  && \
	rm binaryen-*-x86_64-linux.tar.gz && \
	chmod +x binaryen-*/bin/wasm-opt && \
	mv binaryen-*/bin/wasm-opt /usr/local/bin/ && \
	rm -rf binaryen-*/ && \

	# The stable toolchain is used to build ink! itself through the use of the
	# `RUSTC_BOOSTRAP=1` environment variable. We also need to install the
	# `wasm32-unknown-unknown` target since that's the platform that ink! smart contracts
	# run on.
	rustup target add wasm32-unknown-unknown --toolchain stable && \
	rustup component add rust-src --toolchain stable && \
	rustup default stable && \

	# We also use the nightly toolchain to lint ink!. We perform checks using RustFmt,
	# Cargo Clippy, and Miri.
	#
	# Note that we pin the nightly toolchain since it often creates breaking changes during
	# the RustFmt and Clippy stages of the CI.
	rustup toolchain install nightly-2022-07-28 --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy miri rust-src rustc-dev llvm-tools-preview && \

	# Alias pinned toolchain as nightly, otherwise it appears as though we
	# don't have a nightly toolchain (i.e rustc +nightly --version is empty)
	ln -s /usr/local/rustup/toolchains/nightly-2022-07-28-x86_64-unknown-linux-gnu \
		/usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \

	# `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
	cargo install cargo-dylint dylint-link && \

	# Install the latest released version of `cargo-contract`
	cargo install cargo-contract && \

	# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
	# We require `xargo` so that `miri` runs properly
	cargo install grcov rust-covfix xargo && \

	# Automated spell-checking
	cargo install cargo-spellcheck && \

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
