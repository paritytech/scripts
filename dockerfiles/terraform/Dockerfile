FROM alpine:latest

ARG VCS_REF
ARG BUILD_DATE
ARG TERRAFORM_VERSION

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/terraform" \
	io.parity.image.description="ca-certificates git jq make curl gettext; terraform;" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

ADD "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" /tmp
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ terraform && \
	rm /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip


RUN apk add --no-cache \
		ca-certificates git jq make curl gettext; \
	chmod +x /usr/local/bin/terraform

WORKDIR /config

CMD /bin/sh
