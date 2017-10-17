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
	software-properties-common \
	wget \
	zip \
	dpkg-dev \
	python \
	rhash \
	openssl \
	build-essential \
	pkg-config \
	libssl-dev \
	g++ gcc libc6 libc6-dev python make \
	zlib1g-dev \
	libedit-dev \
	libudev-dev

# cmake and llvm ppas. then update ppas
RUN add-apt-repository -y "ppa:george-edison55/cmake-3.x" && \
        add-apt-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main" && \
        apt-get update && \
        apt-get install -y --force-yes cmake llvm-3.7-dev

# install evmjit
RUN git clone https://github.com/debris/evmjit && \
        cd evmjit && \
        mkdir build && cd build && \
        cmake .. && make && make install && cd

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


# show backtraces
ENV RUST_BACKTRACE 1

# Set default user
USER root

# Set build enviroment
# build parity
RUN git clone https://github.com/ethcore/parity && \
        cd parity && \
        git checkout beta && \
        git pull && \
        cargo build --release --verbose --features final && \
        ls /build/parity/target/release/parity &&       \
        strip /build/parity/target/release/parity

RUN file /build/parity/target/release/parity

EXPOSE 8080 8545 8180
ENTRYPOINT ["/build/parity/target/release/parity"]
