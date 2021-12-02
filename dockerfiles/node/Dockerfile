FROM docker.io/library/node:16

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
      io.parity.image.vendor="Parity Technologies" \
      io.parity.image.title="${REGISTRY_PATH}/node" \
      io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/scripts/node/Dockerfile" \
      io.parity.image.revision="${VCS_REF}" \
      io.parity.image.created="${BUILD_DATE}"

RUN apt-get -y update && \
    apt-get install -y ssh && \
# apt clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
# add non-root user
    groupadd -g 1100 nonroot && \
    useradd -u 1100 -g 1100 -s /bin/bash -m nonroot

USER nonroot:nonroot