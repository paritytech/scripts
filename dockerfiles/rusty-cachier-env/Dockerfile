FROM docker.io/library/ruby:2.7-alpine3.16

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
      io.parity.image.vendor="Parity Technologies" \
      io.parity.image.title="${REGISTRY_PATH}/rusty-cachier-env" \
      io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/scripts/rusty-cachier-env/Dockerfile" \
      io.parity.image.revision="${VCS_REF}" \
      io.parity.image.created="${BUILD_DATE}"

RUN apk add --no-cache --update curl unzip bash
