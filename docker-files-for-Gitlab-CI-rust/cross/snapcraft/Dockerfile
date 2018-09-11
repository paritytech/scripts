FROM ubuntu:16.04
MAINTAINER Parity Technologies <devops@parity.io>
WORKDIR /build
# install tools and dependencies
RUN apt-get update && \
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
      snapcraft \
      snapd \
      git \
      ca-certificates \
      file \
      python \
      python-pip \
      zip \
      curl \
      expect \
      nodejs && \
    apt-get clean
# install AWS CLI
RUN pip install awscli
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
