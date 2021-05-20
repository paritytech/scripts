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
  apk add --no-cache postgresql-libs && \
	apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
	python3 -m pip install --no-cache-dir SQLAlchemy[postgresql] query-exporter && \
	apk --purge del .build-deps


EXPOSE 9560

ENTRYPOINT ["python3", "/usr/local/bin/query-exporter"]
