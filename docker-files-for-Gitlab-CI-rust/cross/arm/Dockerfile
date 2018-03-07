FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install arm dependencies and tools
RUN dpkg --add-architecture armhf
RUN	echo '# source urls for armhf \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial main \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main \n\
	deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n\
	deb-src [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main \n # end armhf section' >> /etc/apt/sources.list &&\
	sed -r 's/deb h/deb \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list && \
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& \
	sed -r 's/deb-src h/deb-src \[arch=amd64\] h/g' /etc/apt/sources.list > /tmp/sources-tmp.list&&cat /etc/apt/sources.list &&\
	cp /tmp/sources-tmp.list /etc/apt/sources.list&& echo "next"&&cat /etc/apt/sources.list
RUN	apt update&& \
  apt install -y --no-install-recommends \
  g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf g++ make build-essential \
  curl git ca-certificates file python zip dpkg-dev rhash expect \
	nodejs openssl snapcraft \
	pkg-config libudev-dev libudev-dev:armhf

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs

# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py && pip install awscli

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# setup cargo target
ENV RUST_TARGETS arm-unknown-linux-gnueabihf
ENV TARGET arm-unknown-linux-gnueabihf

# install openssl
ENV OS_COMPILER linux-armv4
ENV AR arm-linux-gnueabihf-ar
ENV CC arm-linux-gnueabihf-gcc
ENV HOME /root
RUN curl -O https://www.openssl.org/source/openssl-1.0.2n.tar.gz && \
  tar xf openssl-1.0.2n.tar.gz && cd openssl-1.0.2n && \
  ./Configure --prefix=${HOME}/openssl ${OS_COMPILER} -fPIC && \
  make && make install && \
  cd .. &&rm -rf openssl-*
# set cross compile ENV
ENV OPENSSL_DIR "/root/openssl"
ENV CPPFLAGS "-I/usr/include"
ENV LDFLAGS "-L/usr/lib/arm-linix-gnueabihf"

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*

#snapcraft ENV
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
