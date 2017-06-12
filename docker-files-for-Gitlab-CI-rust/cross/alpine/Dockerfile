FROM alpine:edge
MAINTAINER Parity Technologies <devops@parity.io>
# install tools and dependencies
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk add --no-cache --update alpine-sdk git curl wget python nodejs file openssl pkgconfig eudev eudev-dev rust cargo libressl libressl-dev perl musl musl-utils hidapi@testing hidapi-dev@testing pkgconf linux-headers nanomsg nanomsg-dev@testing
RUN rm -rf /var/cache/apk/*
# Define bash as default command 
CMD ["/bin/bash"]
# install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    pip install awscli
ENV RUST_BACTRACE 1
