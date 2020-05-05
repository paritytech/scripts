FROM alpine:latest

ARG VCS_REF
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech
ARG HELM_VERSION
ARG KUBE_VERSION

# metadata
ENV VCS_REF=${VCS_REF:-"master"}
ENV BUILD_DATE=${BUILD_DATE:-""}
ENV REGISTRY_PATH=${REGISTRY_PATH:-paritytech}
ENV HELM_VERSION=${HELM_VERSION:-"2.16.6"}
ENV KUBE_VERSION=${KUBE_VERSION:-"1.18.2"}

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
RUN wget -q "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O - | tar -xzO linux-amd64/helm \
	> /usr/local/bin/helm
RUN apk add --no-cache \
		ca-certificates git jq make curl gettext; \
	chmod +x /usr/local/bin/kubectl; \
	chmod +x /usr/local/bin/helm

WORKDIR /config

CMD /bin/sh
