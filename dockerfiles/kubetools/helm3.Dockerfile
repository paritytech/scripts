FROM docker.io/library/alpine:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG HELM_VERSION="3.5.3"
ARG KUBE_VERSION="1.20.0"

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/kubetools" \
    io.parity.image.description="ca-certificates git jq make curl gettext; kube helm;" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kubetools/helm3.Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kubetools/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

RUN apk add --no-cache \
        ca-certificates git jq make curl gettext bash shadow && \
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    curl -L "https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" \
        -o /usr/local/bin/kubectl && \
    # https://github.com/helm/helm/releases
    curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
        -o helm.tar.gz && \
    tar -zxf helm.tar.gz linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64 && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/helm && \
# test
    kubectl version --short=true --client && \
    helm version

RUN set -x \
    && groupadd -g 1000 nonroot \
    && useradd -u 1000 -g 1000 -s /bin/bash -m nonroot \
    && mkdir /config \
    && chown nonroot:nonroot /config

WORKDIR /config

USER nonroot:nonroot
CMD ["/bin/bash"]
