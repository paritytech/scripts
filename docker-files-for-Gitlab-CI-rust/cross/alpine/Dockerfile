FROM alpine:3.7
MAINTAINER Parity Technologies <devops@parity.io>
# install tools and dependencies
RUN apk add --no-cache --update alpine-sdk git curl wget make python nodejs file openssl-dev gcc g++ pkgconfig eudev-dev rust cargo \
	perl musl-dev binutils libusb-dev linux-headers
RUN rm -rf /var/cache/apk/*
# Define bash as default command 
CMD ["/bin/bash"]
# install aws cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python get-pip.py &&\
    pip install awscli
ENV RUST_BACTRACE 1
