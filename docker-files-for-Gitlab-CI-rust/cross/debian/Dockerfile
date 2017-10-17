FROM debian:jessie
MAINTAINER Parity Technologies <devops@parity.io>

# install build dependencies
RUN apt-get -y update && \
    apt-get install -y --force-yes --no-install-recommends \
        g++ gcc libc6 libc6-dev \
        python binutils curl git make file ca-certificates zip dpkg-dev rhash \
	openssl \
	build-essential \
	pkg-config libssl-dev libudev-dev

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces

ENV RUST_BACKTRACE 1
