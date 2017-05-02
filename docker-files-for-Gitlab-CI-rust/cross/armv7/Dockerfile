FROM ubuntu:trusty
MAINTAINER Parity Technologies <devops@parity.io>
# install nodejs
RUN apt-get update&&curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean
# install armv7 dependencies
RUN dpkg --add-architecture armhf &&echo "foreign-architecture armhf" >> /etc/dpkg/dpkg.cfg.d/architectures
RUN	echo '# source urls for armhf \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty main \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty-security main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ trusty-security main \n # end armhf section' >> /etc/apt/sources.list &&\
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&&cat /etc/apt/sources.list &&\
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& echo "next"&&cat /etc/apt/sources.list
RUN	apt-get update -y && \
    	apt-get install -y --force-yes --no-install-recommends \
        g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf libc6-armhf-cross libc6-dev-armhf-cross \
        binutils-arm-linux-gnueabihf curl git make g++ ca-certificates file python zip dpkg-dev rhash \
	openssl \
	build-essential \
	pkg-config libssl-dev libudev-dev crossbuild-essential-armhf
RUN apt-get install libudev-dev:armhf -y

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# target
ENV RUST_TARGETS armv7-unknown-linux-gnueabihf
ENV TARGET armv7-unknown-linux-gnueabihf

# install armv7 targets
RUN rustup target add armv7-unknown-linux-gnueabihf

# install openssl
RUN curl -O https://www.openssl.org/source/openssl-1.0.2k.tar.gz
RUN tar xf openssl-1.0.2k.tar.gz
RUN echo "build openssl"
RUN export OS_COMPILER=linux-armv4&&export AR=arm-linux-gnueabihf-ar&&export CC=arm-linux-gnueabihf-gcc&&cd openssl-1.0.2k&&./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC&&make -j$(nproc)&&make install
ENV OPENSSL_DIR /root/openssl
# cross compile ENV
RUN CPPFLAGS="-I/usr/include"
RUN LDFLAGS="-L/usr/lib/arm-linix-gnueabihf"

# show backtraces
ENV RUST_BACKTRACE 1
