FROM ubuntu:trusty
MAINTAINER Denis S. Soldatov aka General-Beck <general-beck@ethcore.io>

# install armv6 dependencies
RUN apt-get -y update && \
    apt-get install -y --force-yes --no-install-recommends \
        g++-arm-linux-gnueabi gcc-arm-linux-gnueabi libc6-armel-cross libc6-dev-armel-cross \
        binutils-arm-linux-gnueabi curl git make g++ file ca-certificates python zip dpkg-dev rhash \
	openssl \
	build-essential \
	pkg-config libssl-dev libudev-dev

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

# target
ENV RUST_TARGETS arm-unknown-linux-gnueabi
ENV TARGET arm-unknown-linux-gnueabi

# install armv6 toolchain
RUN rustup target add arm-unknown-linux-gnueabi

# install openssl
RUN curl -O https://www.openssl.org/source/openssl-1.0.2k.tar.gz
RUN tar xf openssl-1.0.2k.tar.gz
RUN echo "build openssl"
RUN export OS_COMPILER=linux-armv4&&export AR=arm-linux-gnueabi-ar&&export CC=arm-linux-gnueabi-gcc&&cd openssl-1.0.2k&&./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC&&make -j$(nproc)&&make install
ENV OPENSSL_DIR /root/openssl
# cross compile ENV
RUN CPPFLAGS="-I/usr/include"
RUN LDFLAGS="-L/usr/lib/arm-linix-gnueabi"
# show backtraces
ENV RUST_BACKTRACE 1
