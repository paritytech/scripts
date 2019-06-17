FROM ubuntu:xenial

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/deploy" \
	io.parity.image.description="g++-aarch64-linux-gnu gcc-aarch64-linux-gnu libudev-dev \
libudev-dev:arm64; rustup target aarch64-unknown-linux-gnu" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/deploy/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/deploy/README.md" \
	io.parity.image.revision=${VCS_REF} \
	io.parity.image.created=${BUILD_DATE}

WORKDIR /build

# install tools and dependencies
RUN set -eux; \
  apt -y update; \
  apt install -y --no-install-recommends \
    curl python snapcraft; \
# install AWS CLI
  curl -O https://bootstrap.pypa.io/get-pip.py; \
    python get-pip.py && pip install awscli; \
# cleanup
  apt autoremove -y; \
  apt clean -y; \
  rm -rf /tmp/* /var/tmp/*
