FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install aarch64(armv8) dependencies and tools
RUN dpkg --add-architecture arm64
RUN echo '# source urls for arm64 \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n # end arm64 section' >> /etc/apt/sources.list &&\
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&&cat /etc/apt/sources.list &&\
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& echo "next"&&cat /etc/apt/sources.list
RUN apt update&& \
  apt install -y --no-install-recommends \
  g++-aarch64-linux-gnu gcc-aarch64-linux-gnu g++ make build-essential \
	curl git ca-certificates file python zip dpkg-dev rhash expect \
	nodejs openssl snapcraft \
	pkg-config libudev-dev libudev-dev:arm64

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
ENV RUST_TARGETS aarch64-unknown-linux-gnueabihf
ENV TARGET aarch64-unknown-linux-gnueabihf

# install aarch64 toolchain
RUN rustup target add aarch64-unknown-linux-gnu

# install openssl
ENV OS_COMPILER linux-aarch64
ENV AR aarch64-linux-gnu-ar
ENV CC aarch64-linux-gnu-gcc
ENV HOME /root
RUN curl -O https://www.openssl.org/source/openssl-1.0.2n.tar.gz && \
 tar xf openssl-1.0.2n.tar.gz && cd openssl-1.0.2n && \
 ./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC && \
	make && make install && \
	cd .. &&rm -rf openssl-*

# set cross compile ENV
ENV OPENSSL_DIR "/root/openssl"
ENV CPPFLAGS "-I/usr/include"
ENV LDFLAGS "-L/usr/lib/arm-linix-aarch64"
RUN ln -sf /usr/bin/aarch64-linux-gnu-strip /usr/bin/strip
ENV HOST_CC gcc
ENV HOST_CXX g++

# Rust-related configuration
RUN echo '[target.aarch64-unknown-linux-gnu] \n\
    linker = "aarch64-linux-gnu-gcc" \n\
    ar = "aarch64-linux-gnu-ar" \n' >> /root/.cargo/config

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*

#snapcraft ENV
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
