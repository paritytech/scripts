ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/library/ubuntu:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG UID=10000
ARG GID=10000

# metadata
LABEL summary="Base image for GnuPG operations" \
	name="${REGISTRY_PATH}/gnupg" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="GnuPG base container" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/gnupg/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/gnupg/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN apt-get update && apt-get install -yq --no-install-recommends ca-certificates bash jq unzip curl && \
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
	unzip "/tmp/awscliv2.zip" && rm "/tmp/awscliv2.zip" && \
	/aws/install && rm -rf /aws && \
	apt -yq remove ca-certificates unzip && apt -yq autoremove && \
	aws --version

WORKDIR /scripts

COPY . .

RUN set -x \
	&& groupadd -g $GID nonroot \
	&& useradd -u $UID -g $GID -s /bin/bash -m nonroot

USER nonroot:nonroot

ENTRYPOINT [ "./releng-scripts" ]
