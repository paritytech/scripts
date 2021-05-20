FROM docker.io/library/alpine:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

ENV PROM_VERSION=2.19.0

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/tools" \
	io.parity.image.description="curl git jq rsync make gettext gnupg bash promtool" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/tools/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/tools/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"


RUN apk add --no-cache curl git jq rsync make gettext gnupg bash

RUN curl -sS -L "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz" \
  		--output prometheus.tar.gz && \
	tar -xzf prometheus.tar.gz prometheus-${PROM_VERSION}.linux-amd64/promtool && \
	mv prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin && \
	rm -rf prometheus.tar.gz prometheus-${PROM_VERSION}.linux-amd64

CMD ["/bin/sh"]
