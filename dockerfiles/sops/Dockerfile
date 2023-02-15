FROM docker.io/library/alpine:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG SOPS_VERSION
ARG VAULT_VERSION

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/sops" \
	io.parity.image.description="ca-certificates git jq make curl gettext; sops;" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN apk add --no-cache \
		ca-certificates git jq make curl gettext bash shadow; \
	curl -L "https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux"  \
		-o /usr/local/bin/sops; \
	chmod +x /usr/local/bin/sops

RUN	curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
		-o vault.zip; \
	unzip vault.zip	-d /usr/local/bin/vault; \
	rm vault.zip; \
	chmod +x /usr/local/bin/vault

RUN set -x \
    && groupadd -g 1000 nonroot \
    && useradd -u 1000 -g 1000 -s /bin/bash -m nonroot \
    && mkdir /config \
    && chown nonroot:nonroot /config

WORKDIR /config

USER nonroot:nonroot
CMD ["/bin/bash"]
