FROM debian:stretch
MAINTAINER Parity Technologies <devops@parity.io>

# install build dependencies
RUN apt-get -y update && \
  apt-get install -y --allow --no-install-recommends \
  g++ gcc libc6 libc6-dev make build-essential \
  curl git ca-certificates file python zip dpkg-dev rhash expect \
	nodejs openssl snapcraft \
	pkg-config libudev-dev libudev-dev:arm64

#install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
	  apt-get install -y nodejs

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*
