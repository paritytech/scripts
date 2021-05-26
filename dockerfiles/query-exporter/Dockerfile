FROM docker.io/library/python:3-alpine

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
  io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/query-exporter" \
	io.parity.image.source="https://github.com/paritytech/polkadot/blob/${VCS_REF}/scripts/docker/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
  io.parity.image.created="${BUILD_DATE}"

RUN \
  apk add --no-cache postgresql-libs bash shadow && \
	apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
	python3 -m pip install --no-cache-dir SQLAlchemy[postgresql] query-exporter && \
	apk --purge del .build-deps

RUN set -x \
    && groupadd -g 1000 nonroot \
    && useradd -u 1000 -g 1000 -s /bin/bash -m nonroot

EXPOSE 9560

USER nonroot:nonroot
ENTRYPOINT ["python3", "/usr/local/bin/query-exporter"]
