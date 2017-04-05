FROM ubuntu:14.04
MAINTAINER Parity Technologies <devops@parity.io>
WORKDIR /build

# install tools and dependencies
RUN apt-get -y update && \
        apt-get install -y --force-yes --no-install-recommends \
        curl \
        git \
        file \
        binutils \
	binutils-dev \
	make \
	ca-certificates \
	g++ \
	zip \
	dpkg-dev \
	python \
	rhash \
	openssl \
	build-essential \
	pkg-config \
	libssl-dev \
	libudev-dev 

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# setup rust beta and nightly channel's
RUN rustup install beta
RUN rustup install nightly

# setup default stable channel
RUN rustup default stable

#rustup show
RUN rustup show

# show backtraces
ENV RUST_BACKTRACE 1

# Set default user
USER root


