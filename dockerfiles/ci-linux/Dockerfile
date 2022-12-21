ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

ARG YJ_CHECKSUM=8ce43e40fda9a28221dabc0d7228e2325d1e959cd770487240deb47e02660986
ARG YJ_PATH=/bin/yq

# metadata
LABEL summary="Image for Substrate-based projects." \
	name="${REGISTRY_PATH}/ci-linux" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Inherits from base-ci-linux; wasm-gc, wasm-bindgen-cli, wasm-pack, cargo-audit, cargo-web, cargo-deny" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

# install tools and dependencies
RUN set -eux && \
	# install `rust-src` component for ui test
	rustup component add rust-src rustfmt clippy && \
	# install specific Rust nightly, default is stable, use minimum components
	rustup toolchain install nightly-2022-11-16 --profile minimal --component rustfmt clippy && \
	# "alias" pinned nightly-2022-11-16 toolchain as nightly
	ln -s /usr/local/rustup/toolchains/nightly-2022-11-16-x86_64-unknown-linux-gnu /usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu && \
	# install wasm toolchain
	rustup target add wasm32-unknown-unknown && \
	rustup target add wasm32-unknown-unknown --toolchain nightly && \
	# install cargo tools
	cargo install cargo-web wasm-pack cargo-deny cargo-spellcheck cargo-nextest cargo-hack \
	            mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed && \
	# diener 0.4.6 NOTE: before upgrading please test new version with companion build
	# example can be found here: https://github.com/paritytech/substrate/pull/12710
	cargo install --git https://github.com/paritytech/diener --rev 6497d6a49a199e4b0a8d08b58c76f6e799eea4f1 && \

	# diesel-cli is used by the publishing automation (publish-crates script)
	cargo install --quiet diesel_cli --version 1.4.1 --no-default-features --features postgres && \

	# postgres & sudo are used by the publishing automation (publish-crates script)
	apt install -y --no-install-recommends postgresql-11 libpq-dev sudo && \

	# yj is used by the publishing automation (publish-crates script)
	curl -sSLf -o "$YJ_PATH" https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64 && \
	echo "$YJ_CHECKSUM $YJ_PATH" | sha256sum --check && \
	chmod +x "$YJ_PATH" && \

	# wasm-bindgen-cli version should match the one pinned in substrate
	# https://github.com/paritytech/substrate/blob/master/bin/node/browser-testing/Cargo.toml#L15
	cargo install --version 0.2.73 wasm-bindgen-cli && \
	# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install wasm-gc && \
	# versions
	rustup show && \
	cargo --version && \
	# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	# cargo clean up
	# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache
