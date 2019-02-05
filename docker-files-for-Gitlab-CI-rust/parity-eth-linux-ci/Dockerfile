FROM rust:stretch
LABEL maintainer="Parity Technologies <devops-team@parity.io>"

# install tools and dependencies
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake ca-certificates g++ rhash \
	gcc pkg-config libudev-dev time

# removed:
# binutils binutils-dev snapcraft gettext file python build-essential zip dpkg-dev rpm libssl-dev openssl ruby-dev

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
# show backtraces
ENV RUST_BACKTRACE 1

# pre-download repositories
RUN git clone https://github.com/paritytech/parity-ethereum.git . && \
	git submodule update --init --recursive

VOLUME /parity-ethereum/target $CARGO_HOME
