FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install tools and dependencies
RUN apt -y update && \
  apt install -y --no-install-recommends curl python snapcraft
# install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && pip install awscli

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*
