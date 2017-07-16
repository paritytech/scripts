FROM ubuntu:trusty
MAINTAINER Parity Technologies <devops@parity.io>
# install nodejs
RUN apt-get update&&curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean
# install aarch64(armv8) dependencies
RUN dpkg --add-architecture arm64 &&echo "foreign-architecture arm64" >> /etc/dpkg/dpkg.cfg.d/architectures
RUN	echo '# source urls for arm64 \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty main \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main \n\
	deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty-security main \n\
	deb-src [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ trusty-security main \n # end arm64 section' >> /etc/apt/sources.list &&\
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&&cat /etc/apt/sources.list &&\
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& echo "next"&&cat /etc/apt/sources.list
RUN	apt-get update -y && \
    	apt-get install -y --force-yes --no-install-recommends \
        g++-aarch64-linux-gnu gcc-aarch64-linux-gnu libc6-arm64-cross libc6-dev-arm64-cross \
	binutils-aarch64-linux-gnu curl git make g++ ca-certificates file python zip dpkg-dev rhash \
	openssl \
	build-essential \
	pkg-config libssl-dev libudev-dev crossbuild-essential-arm64
#RUN
#RUN apt-get build-dep -a arm64 openssl libssl-dev -y&&apt-get source openssl -o APT::Get::Host-Architecture=arm64 --compile
#RUN apt-get build-dep -a arm64 libudev-dev -y
RUN apt-get install libudev-dev:arm64 nodejs:arm64 -y


# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# target
ENV RUST_TARGETS aarch64-unknown-linux-gnueabihf
ENV TARGET aarch64-unknown-linux-gnueabihf
# install aarch64 toolchain
RUN rustup target add aarch64-unknown-linux-gnu

# install openssl
RUN curl -O https://www.openssl.org/source/openssl-1.0.2k.tar.gz
RUN tar xf openssl-1.0.2k.tar.gz
RUN echo "build openssl"
RUN export OS_COMPILER=linux-aarch64&&export AR=aarch64-linux-gnu-ar&&export CC=aarch64-linux-gnu-gcc&&cd openssl-1.0.2k&&./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC&&make -j$(nproc)&&make install
ENV OPENSSL_DIR /root/openssl
# cross compile ENV
RUN CPPFLAGS="-I/usr/include"
RUN LDFLAGS="-L/usr/lib/arm-linix-aarch64"
# show backtraces
ENV RUST_BACKTRACE 1
