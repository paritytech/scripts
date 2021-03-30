FROM ruby:2.7-alpine

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
      io.parity.image.vendor="Parity Technologies" \
      io.parity.image.title="${REGISTRY_PATH}/node-bench-regression-guard" \
      io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/scripts/node-bench-regression-guard/Dockerfile" \
      io.parity.image.revision="${VCS_REF}" \
      io.parity.image.created="${BUILD_DATE}"

RUN apk add --no-cache --update curl unzip
COPY node-bench-regression-guard/node-bench-regression-guard /usr/local/bin/node-bench-regression-guard

ENTRYPOINT ["node-bench-regression-guard"]
