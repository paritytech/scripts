ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/gnupg:latest

ARG VCS_REF=master
ARG BUILD_DATE=""

# metadata
LABEL summary="RPM packaging/signing toolchain" \
	name="${REGISTRY_PATH}/rpm" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="RPM packaging/signing toolchain" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/rpm/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/rpm/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

USER root
RUN apt-get install -yq --no-install-recommends rpm

USER nonroot:nonroot

COPY rpm/rpmmacros /home/nonroot/.rpmmacros
