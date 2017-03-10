FROM centos:7.3.1611
MAINTAINER Parity Technologies <devops@parity.io>

# install tools and dependencies
RUN yum install -y epel-release &&\
    yum install -y git curl file make binutils gcc-c++ gcc python rhash openssl-devel build-essential pkg-config libudev-devel --enablerepo=epel 
# install rustup 
#RUN curl https://sh.rustup.rs -sSf | sh
RUN curl -sSf https://static.rust-lang.org/rustup.sh -o rustup.sh &&\ 
    sh rustup.sh --disable-sudo --yes --channel=stable
# install nodejs & npm
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - &&\
    yum -y install nodejs
# install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    pip install awscli
