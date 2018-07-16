FROM ubuntu:latest
MAINTAINER Parity Technologies <devops@parity.io>
WORKDIR /build
# install tools and dependencies
RUN apt-get update && \
        apt-get dist-upgrade --yes && \
	apt-get install --yes --no-install-recommends \
        snapcraft git snapd ca-certificates file python zip curl expect nodejs \
	&& \ 
	apt-get autoclean --yes && \ 
	apt-get clean --yes
# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
