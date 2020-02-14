FROM registry.parity.io/parity/infrastructure/scripts/base-ci-linux:latest

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/substrate-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux. \
rust stable, rust nightly, cargo-audit, sccache (redis), wasm-gc" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# Mozilla's Ubuntu PPA key
COPY utility/mozilla.key /etc/apt/trusted.gpg.d/ubuntu-mozilla.gpg

# install tools and dependencies
RUN set -eux; \
	echo "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu bionic main" \
		> /etc/apt/sources.list.d/mozilla.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		firefox; \
# install cargo tools
	cargo install cargo-audit cargo-web wasm-pack; \
# install wasm toolchain
	rustup target add wasm32-unknown-unknown; \
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc; \
# versions
	rustup show; \
	cargo --version; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf $CARGO_HOME/registry; \
# removes toolchain's html docs and autocompletions (>300M for each toolchain)
	rm -rf /usr/local/rustup/toolchains/*/share
