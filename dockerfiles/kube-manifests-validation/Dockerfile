FROM docker.io/debian:12-slim

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG HELM_VERSION=3.12.2
ARG GATOR_VERSION=3.12.0
ARG DATREE_VERSION=1.9.19
ARG YQ_VERSION=4.34.2
ARG K8S_SCHEMA_VERSION=1.25.9
ARG K8S_SCHEMA_REPO_COMMIT_SHA=a43aa7eceaf4c32c5f45c9fc477588e7a12f18b6
ARG CRDS_SCHEMA_REPO_COMMIT_SHA=8f0604e873746d6b2d49794e5b37768460e7b545
ARG K8S_SCHEMA_DIR=/schemas/k8s
ARG K8S_CRDS_DIR=/schemas/crds

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/kube-manifests-validation" \
    io.parity.image.description="Tools for validating Kubernetes manifest files" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kube-manifests-validation/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/kube-manifests-validation/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

RUN apt-get update && \
  apt-get install -y curl git moreutils unzip && \
  rm -rf /var/lib/apt/lists/*

# Install tools
RUN set -eu; \
  # helm
  curl -fSsL -o - https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz \
  | tar zx --strip 1 -C /usr/local/bin linux-amd64/helm && \
  \
  # gator
  curl -fSsL -o - https://github.com/open-policy-agent/gatekeeper/releases/download/v${GATOR_VERSION}/gator-v${GATOR_VERSION}-linux-amd64.tar.gz \
  | tar zx -C /usr/local/bin gator && \
  \
  # datree
  curl -fSsL -o /tmp/datree.zip https://github.com/datreeio/datree/releases/download/$DATREE_VERSION/datree-cli_${DATREE_VERSION}_Linux_x86_64.zip && \
  unzip /tmp/datree.zip -d /usr/local/bin datree && \
  rm -f /tmp/datree.zip && \
  \
  # yq
  curl -fSsL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
  chmod +x /usr/local/bin/yq

# Download K8s schemas
RUN set -eu; \
  mkdir -p $K8S_SCHEMA_DIR $K8S_CRDS_DIR && \
  git clone --no-checkout --filter=blob:none https://github.com/yannh/kubernetes-json-schema.git $K8S_SCHEMA_DIR && \
  cd $K8S_SCHEMA_DIR && \
  git sparse-checkout set --cone && git checkout $K8S_SCHEMA_REPO_COMMIT_SHA && \
  git sparse-checkout set v$K8S_SCHEMA_VERSION v$K8S_SCHEMA_VERSION-standalone v$K8S_SCHEMA_VERSION-standalone-strict && \
  \
  cd $K8S_CRDS_DIR && \
  git init && \
  git remote add origin https://github.com/datreeio/CRDs-catalog.git && \
  git fetch origin $CRDS_SCHEMA_REPO_COMMIT_SHA && \
  git reset --hard FETCH_HEAD && \
  rm -rf $K8S_SCHEMA_DIR/.git $K8S_CRDS_DIR/.git

WORKDIR /app

RUN mkdir -p /root/.datree
COPY ./datree-policies.yaml ./
COPY ./datree-config.yaml /root/.datree/config.yaml

WORKDIR /git
