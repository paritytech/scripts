ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/paritytech/gnupg:latest

# 'Parity Security Team <security@parity.io>'
ARG KEY_ID=9D4B2B6EB8F97156D19669A9FF0812D491B96798
ARG KEY_SERVER=hkps://keys.mailvelope.com
ARG VCS_REF=master
ARG BUILD_DATE=""

# metadata
LABEL summary="Base image with Parity-Keyring" \
	name="${REGISTRY_PATH}/parity-keyring" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Parity Keyring base container" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/parity-keyring/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/parity-keyring/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

USER root

RUN gpg --recv-keys --keyserver $KEY_SERVER $KEY_ID && \
	gpg --export $KEY_ID > /usr/share/keyrings/parity.gpg && \
	echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list && \
	apt update && \
	apt install parity-keyring

USER nonroot:nonroot

RUN gpg /usr/share/keyrings/parity.gpg | grep -v expired

WORKDIR /home/nonroot
CMD ["/bin/bash"]
