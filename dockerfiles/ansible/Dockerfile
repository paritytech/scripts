FROM python:3.7.6-stretch

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

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

RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

WORKDIR /work
