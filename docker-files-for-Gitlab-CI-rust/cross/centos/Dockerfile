FROM centos:latest
MAINTAINER Parity Technologies <devops@parity.io>

# install tools and dependencies
RUN yum install -y epel-release &&\
    yum install -y git wget curl file make binutils gcc-c++ gcc python rhash openssl-devel build-essential pkg-config libudev-devel --enablerepo=epel 
# install glibc-2.18
#RUN wget http://ftp.heanet.ie/mirrors/gnu/libc/glibc-2.18.tar.gz&&tar xvfz #glibc-2.18.tar.gz&&cd glibc-2.18&&mkdir build&&cd build&&../configure --prefix=/opt/glibc-2.18&&make&&make install
#ENV LD_LIBRARY_PATH /opt/glibc-2.18/lib:$LD_LIBRARY_PATH
RUN yum -y update glibc

# install rustup 
#RUN curl https://sh.rustup.rs -sSf | sh
RUN curl -sSf https://static.rust-lang.org/rustup.sh -o rustup.sh &&\ 
    sh rustup.sh --disable-sudo --yes --channel=stable
# install nodejs & npm
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - &&\
    yum -y install nodejs
# install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    pip install awscli
