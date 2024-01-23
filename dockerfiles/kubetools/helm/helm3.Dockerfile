FROM docker.io/library/alpine:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG HELM_VERSION
ARG HELMFILE_VERSION
ARG HELM_DIFF_PLUGIN_VERSION
ARG HELM_SECRETS_VERSION
ARG KUBE_VERSION
ARG VALS_VERSION
ARG VAULT_VERSION
ARG KUSTOMIZE_VERSION

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
        ca-certificates git jq yq make curl gettext bash shadow python3 py3-pip py3-kubernetes && \
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    echo "Installing kubectl" && \
    curl -L "https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" \
        -o /usr/local/bin/kubectl && \
    # https://github.com/helm/helm/releases
    echo "Installing helm" && \
    curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
        -o helm.tar.gz && \
    tar -zxf helm.tar.gz linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64 && \
    # https://github.com/roboll/helmfile/releases
    echo "Installing helmfile" && \
    curl -L "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" \
        -o /usr/local/bin/helmfile && \
    # Install vals: https://github.com/variantdev/vals/releases
    echo "Installing vals" && \
    curl -L "https://github.com/variantdev/vals/releases/download/v${VALS_VERSION}/vals_${VALS_VERSION}_linux_amd64.tar.gz" \
        -o vals.tar.gz && \
    tar -zxf vals.tar.gz vals && \
    mv vals /usr/local/bin/ && \
    # Install vault
    echo "Installing vault" && \
    wget -qO- "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
      | unzip -d /usr/local/bin - && \
    # Install kustomize
    echo "Installing kustomize" && \
    curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" \
        -o kustomize.tar.gz && \
    tar -zxf kustomize.tar.gz kustomize && \
    mv kustomize /usr/local/bin/kustomize && \
    rm -rf kustomize.tar.gz && \
    chmod +x  /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/vault && \
    # test
    kubectl version --short=true --client && \
    helm version  && \
    helmfile version && \
    vault --version && \
    vals version && \
    kustomize version

RUN set -x \
    && groupadd -g 10000 nonroot \
    && useradd -u 10000 -g 10000 -s /bin/bash -m nonroot \
    && mkdir /config \
    && chown nonroot:nonroot /config

WORKDIR /config

USER nonroot:nonroot

    # https://github.com/databus23/helm-diff/releases
RUN helm plugin install https://github.com/databus23/helm-diff --version "v${HELM_DIFF_PLUGIN_VERSION}" && \
    # https://github.com/jkroepke/helm-secrets
    helm plugin install https://github.com/jkroepke/helm-secrets --version "v${HELM_SECRETS_VERSION}" && \
    helm plugin list
CMD ["/bin/bash"]
