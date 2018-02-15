FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

# install i686 dependencies and tools
RUN dpkg --add-architecture i386
RUN apt update && \
  apt install -y --no-install-recommends \
  g++ gcc gcc-multilib g++-multilib make build-essential \
  curl git ca-certificates file python zip dpkg-dev rhash expect \
	nodejs openssl snapcraft \
	pkg-config libudev-dev libudev-dev:i386

#install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
  apt-get install -y nodejs

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# set cargo target
ENV RUST_TARGETS i686-unknown-linux-gnu
ENV TARGET i686-unknown-linux-gnu

# install i686 toolchain
RUN rustup target add i686-unknown-linux-gnu

# install openssl
ENV OS_COMPILER linux-elf
ENV HOME /root
RUN curl -O https://www.openssl.org/source/openssl-1.0.2n.tar.gz && \
  tar xf openssl-1.0.2n.tar.gz && cd openssl-1.0.2n && \
  ./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC -m32 && \
  make depend && make && make install && \
	cd .. &&rm -rf openssl-*

# set cross compile ENV
ENV OPENSSL_DIR "/root/openssl"
ENV CPPFLAGS "-I/usr/include"
ENV LDFLAGS "-L/usr/lib32"

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*

#snapcraft ENV
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
