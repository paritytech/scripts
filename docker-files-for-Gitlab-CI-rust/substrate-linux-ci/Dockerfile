# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly-slim/Dockerfile
FROM rustlang/rust:nightly-slim

# metadata
# LABEL maintainer="devops-team@parity.io" \
# 	vendor="Parity Technologies" \
# 	name="parity/rust-parity-ethereum-build" \
# 	description="This is for CI build stage for Parity Ethereum linux binary." \
# 	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
# 	url="https://gitlab.com/paritytech"

WORKDIR /builds/parity/substrate/

# install tools and dependencies
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake g++ rhash \
	pkg-config libudev-dev time \
	libssl-dev
# ca-certificates gcc

RUN rustup install beta \
# setup default stable channel
	rustup default stable \
	cargo install cargo-audit sccache \
# install wasm toolchain for polkadot
	rustup target add wasm32-unknown-unknown --toolchain nightly \
# Install wasm-gc. It's useful for stripping slimming down wasm binaries.
# (polkadot)
	cargo +nightly install --git https://github.com/alexcrichton/wasm-gc

# compiler ENV
ENV CC=gcc \
	CXX=g++ \
# cache handlers
	CARGO_HOME=/cargo/substrate/cargo \
	RUSTC_WRAPPER=sccache \
	SCCACHE_DIR=/cargo/substrate/sccache \
# show backtraces
	RUST_BACKTRACE=1

# #
# git clone https://github.com/paritytech/substrate.git .
# #
# scripts/build.sh
# #
# time cargo build --release --verbose;
# mkdir -p ./artifacts;
# mv ./target/release/substrate ./artifacts/.
# echo -n "Substrate version = "
# if [ "${CI_COMMIT_TAG}" ]; then
#   echo "${CI_COMMIT_TAG}" | tee ./artifacts/VERSION;
# else
#   ./artifacts/substrate --version |
#   sed -n -r 's/^substrate ([0-9.]+.*-[0-9a-f]{7,13})-.*$/\1/p' |
#   tee ./artifacts/VERSION;
# fi
# sha256sum ./artifacts/substrate | tee ./artifacts/substrate.sha256
# echo "\n# building node-template\n"
# ./scripts/node-template-release.sh ./artifacts/substrate-node-template.tar.gz
# cp -r scripts/docker/* ./artifacts
