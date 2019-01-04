FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install tools and dependencies
RUN apt-get -y update && \
  apt-get install -y --no-install-recommends \
	software-properties-common curl git file binutils binutils-dev snapcraft \
  make cmake ca-certificates g++ zip dpkg-dev python rhash rpm openssl gettext \
  build-essential clang libclang-dev pkg-config libssl-dev libudev-dev ruby-dev time

#install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - 
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -y update && apt-get install -y --no-install-recommends \ 
  nodejs yarn

# install java8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt install -y oracle-java8-installer

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && pip install awscli

# install FPM
RUN gem install fpm

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# setup rust beta and nightly channel's
RUN rustup install beta
RUN rustup install nightly

# install wasm toolchain for polkadot
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
# Install wasm-gc. It's useful for stripping slimming down wasm binaries. 
# (polkadot)
RUN cargo +nightly install --git https://github.com/alexcrichton/wasm-gc

# setup default stable channel
RUN rustup default stable

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*

#compiler ENV
ENV CC gcc
ENV CXX g++

#snapcraft ENV
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
