# triggers image autoupdate with the new Rust release
FROM rust:slim as notifier
# temporary support of 16.04 with its Clib
FROM ubuntu:xenial as builder
LABEL maintainer="Parity Technologies <devops-team@parity.io>"
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="parity/rust-parity-ethereum-build" \
      org.label-schema.description="This is for CI build stage for Parity Ethereum linux binary." \
      org.label-schema.url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
      org.label-schema.schema-version="1.0"


# install tools and dependencies
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake ca-certificates g++ rhash \
	gcc pkg-config libudev-dev time

# removed:
# binutils binutils-dev snapcraft gettext file python build-essential zip dpkg-dev rpm libssl-dev openssl ruby-dev

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

#install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get -y update && apt-get install -y --no-install-recommends \
	nodejs yarn

RUN mkdir /parity-ethereum
WORKDIR /parity-ethereum

RUN cargo install cargo-audit sccache

# compiler ENV
ENV CC gcc
ENV CXX g++
ENV CARGO_TARGET x86_64-unknown-linux-gnu
ENV CARGO_HOME /parity-ethereum/.cargo/
# cache handler
ENV RUSTC_WRAPPER sccache
ENV SCCACHE_DIR $CARGO_HOME/sccache
# show backtraces
ENV RUST_BACKTRACE 1

# pre-download repositories
RUN git clone https://github.com/paritytech/parity-ethereum.git . && \
	git submodule update --init --recursive

VOLUME /parity-ethereum/artifacts $CARGO_HOME
