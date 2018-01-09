FROM ubuntu:trusty
MAINTAINER Parity Technologies <devops@parity.io>

# install i686 dependencies
RUN apt-get update&&curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean
# install i686 dependencies
RUN dpkg --add-architecture i386 &&echo "foreign-architecture i386" >> /etc/dpkg/dpkg.cfg.d/architectures

RUN apt-get -y update && \
    apt-get install -y --force-yes --no-install-recommends \
        g++ gcc gcc-multilib g++-multilib libc6 libc6-dev \
        python binutils curl git make file ca-certificates zip dpkg-dev rhash \
	openssl \
	build-essential \
	pkg-config openssl libssl-dev libudev-dev
RUN apt-get install libudev-dev:i386 -y

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
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
ENV RUST_TARGETS i686-unknown-linux-gnu
ENV TARGET i686-unknown-linux-gnu
# install target toolchain
RUN rustup target add i686-unknown-linux-gnu

# install openssl
RUN curl -O https://www.openssl.org/source/openssl-1.0.2n.tar.gz
RUN tar xf openssl-1.0.2n.tar.gz
RUN echo "build openssl"
RUN export OS_COMPILER=linux-elf&&cd openssl-1.0.2n&&./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC -m32&&make depend&&make -j$(nproc)&&make install
ENV OPENSSL_DIR /root/openssl
# cross compile ENV
RUN CPPFLAGS="-I/usr/include"
RUN LDFLAGS="-L/usr/lib32"
# show backtraces

ENV RUST_BACKTRACE 1
