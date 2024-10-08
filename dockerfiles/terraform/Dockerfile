FROM docker.io/library/alpine:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG TERRAFORM_VERSION=1.5.6
ARG VAULT_VERSION=1.17.3

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/terraform" \
	io.parity.image.description="ca-certificates git jq make curl gettext; terraform;" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN apk add --no-cache \
		ca-certificates git jq make curl gettext bash shadow openssh-client python3 py3-requests \
		&& ln -sf python3 /usr/bin/python; \
	curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
		-o terraform.zip; \
	unzip terraform.zip	-d /usr/local/bin/ terraform; \
	rm terraform.zip; \
	chmod +x /usr/local/bin/terraform

RUN	curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
		-o vault.zip; \
	unzip vault.zip	-d /usr/local/bin/ vault; \
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
