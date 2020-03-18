FROM debian:buster

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/rust-builder" \
	io.parity.image.description="libssl-dev, clang, libclang-dev, lld, cmake, make, git, pkg-config, \
curl, time, rhash, ca-certificates, firefox-esr, geckodriver; \
rust stable, rust nightly, cargo-audit, sccache, wasm-gc, wasm-bindgen" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/rust-builder/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown
COPY utility/rust-builder-config /root/.cargo/config

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    CC=clang \
	CXX=clang
# download rustup
ADD "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" rustup-init

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		libssl-dev clang lld libclang-dev cmake make firefox-esr \
		git pkg-config curl time rhash ca-certificates; \
# install geckodriver
	curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest \
		| grep 'browser_download_url.*linux64.tar.gz"' \
		| cut -d : -f 2,3 | tr -d \" | xargs -n 1 curl -sSL \
		| tar -xzC /usr/bin; \
# set a link to clang
	ln -sf /usr/bin/clang /usr/bin/cc; \
# install rustup
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path --default-toolchain stable; \
	rm rustup-init; \
	chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
# install Rust nightly, default is stable
	rustup install nightly; \
# install cargo tools
	cargo install \
		cargo-audit cargo-web wasm-pack; \
	cargo install sccache --features redis; \
# TODO: install published version once 0.2.60 gets released
	cargo install wasm-bindgen-cli; \
# install wasm toolchain
	rustup target add wasm32-unknown-unknown; \
	rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install wasm-gc. It's useful for stripping slimming down wasm binaries (polkadot)
	cargo +nightly install wasm-gc; \
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

# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1
