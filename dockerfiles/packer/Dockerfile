FROM docker.io/paritytech/mitogen:latest

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG PACKER_VERSION=1.8.7
ARG VAULT_VERSION=1.17.3

LABEL io.parity.image.authors="devops-team@parity.io" \
        io.parity.image.vendor="Parity Technologies" \
        io.parity.image.title="${REGISTRY_PATH}/packer" \
        io.parity.image.description="packer" \
        io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/packer/Dockerfile" \
        io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/packer/README.md" \
        io.parity.image.revision="${VCS_REF}" \
        io.parity.image.created="${BUILD_DATE}"

USER root:root
SHELL ["/bin/bash", "-c"]

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libarchive-tools \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir hvac # for ansible community.hashi_vault

RUN set -euo pipefail \
    && curl -L "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
    | bsdtar -xf - -C /usr/local/bin packer \
    && chmod +x /usr/local/bin/packer \
    \
    && curl -L "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
    | bsdtar -xf - -C /usr/local/bin vault \
    && chmod +x /usr/local/bin/vault

USER 10000:10001
