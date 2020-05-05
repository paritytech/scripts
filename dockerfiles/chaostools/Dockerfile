FROM node:12-alpine

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech
ARG KUBE_VERSION="1.14.6"

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/kubetools" \
	io.parity.image.description="ca-certificates git jq make curl gettext; kube helm;" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kubetools/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kubetools/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

ADD "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" \
	/usr/local/bin/kubectl

RUN apk add --no-cache \
		ca-certificates git jq make curl gettext; \
	chmod +x /usr/local/bin/kubectl; \

WORKDIR /config

CMD /bin/sh
