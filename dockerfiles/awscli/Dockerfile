FROM docker.io/library/python:3.6-alpine

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/awscli" \
	io.parity.image.description="awscli" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/awscli/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/awscli/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN pip install awscli; \
	apk add --no-cache bash shadow

RUN set -x \
    && groupadd -g 1000 nonroot \
    && useradd -u 1000 -g 1000 -s /bin/bash -m nonroot

COPY utility/awscli-config /etc/aws.config
ENV AWS_CONFIG_FILE /etc/aws.config

USER nonroot:nonroot
CMD ["/bin/bash"]
