ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/library/ubuntu:latest

# 'Parity Security Team <security@parity.io>'
ARG GPG_KEYID=9D4B2B6EB8F97156D19669A9FF0812D491B96798
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG UID=1000
ARG GID=1000

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

RUN apt-get update && apt-get install -yq --no-install-recommends bash ca-certificates curl gnupg

RUN set -x \
    && groupadd -g $GID nonroot \
    && useradd -u $UID -g $GID -s /bin/bash -m nonroot

USER nonroot:nonroot

RUN curl -LfSs "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${GPG_KEYID}&options=mr&exact=on" | gpg --import - \
  && gpg --list-keys

WORKDIR /home/nonroot
CMD ["/bin/bash"]
