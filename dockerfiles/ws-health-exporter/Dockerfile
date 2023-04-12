FROM docker.io/library/python:3.10.10-slim-bullseye

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ws-health-exporter" \
	io.parity.image.description="A health checker for Substrate-based nodes" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ws-health-exporter/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ws-health-exporter/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN pip install --no-cache-dir prometheus-client websocket-client apscheduler flask environs waitress
COPY ws-health-exporter/exporter.py .

USER nobody:nogroup

EXPOSE 8001
CMD ["python", "./exporter.py"]
