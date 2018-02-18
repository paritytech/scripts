FROM centos:latest
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install tools and dependencies
RUN yum install -y epel-release &&yum-config-manager --enable epel-testing && yum -y update --enablerepo=epel-testing&&\
    yum install -y rpm-build ruby rubygems git wget curl file make automake autoconf libtool \
    curl-devel zlib-devel ruby-devel binutils gcc-c++ gcc python zip rhash openssl-devel \
    build-essential pkg-config libudev-devel --enablerepo=epel-testing
RUN yum -y update glibc

# install nodejs & npm
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - &&\
    yum -y install nodejs

# install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    pip install awscli

#install fpm
RUN gem update
RUN gem install --no-ri --no-rdoc fpm

# install rustup
RUN curl -sSf https://static.rust-lang.org/rustup.sh -o rustup.sh &&\
    sh rustup.sh --disable-sudo --yes --channel=stable

# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN rm -rf /tmp/* /var/tmp/*
