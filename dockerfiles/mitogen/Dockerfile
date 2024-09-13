FROM docker.io/library/python:3.12-slim

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG VAULT_VERSION=1.17.3

LABEL io.parity.image.authors="devops-team@parity.io" \
        io.parity.image.vendor="Parity Technologies" \
        io.parity.image.title="${REGISTRY_PATH}/mitogen" \
        io.parity.image.description="mitogen" \
        io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/mitogen/Dockerfile" \
        io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/mitogen/README.md" \
        io.parity.image.revision="${VCS_REF}" \
        io.parity.image.created="${BUILD_DATE}"

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass ssh-client rsync tini curl git ruby unzip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir ansible==10.4 google-auth requests jmespath dnspython

RUN curl -fSL -o /usr/local/bin/subkey 'https://releases.parity.io/substrate/x86_64-debian%3Astretch/v3.0.0/subkey/subkey' \
    && chmod +x /usr/local/bin/subkey \
    && curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -o vault.zip \
    && unzip vault.zip -d /usr/local/bin vault \
    && chmod +x /usr/local/bin/vault

ENV ANSIBLE_STRATEGY=mitogen_linear
ENV ANSIBLE_STRATEGY_PLUGINS=/opt/mitogen/ansible_mitogen/plugins/strategy
RUN  cd /opt && git clone --depth 1 --branch v0.3.9 https://github.com/mitogen-hq/mitogen.git

ARG WORKDIR=/work
RUN groupadd --gid 10001 nonroot && \
    useradd  --home-dir /home/nonroot \
             --create-home \
             --shell /bin/bash \
             --gid nonroot \
             --groups nonroot \
             --uid 10000 nonroot
RUN chown -R nonroot. /home/nonroot
RUN mkdir ${WORKDIR}
RUN chown -R nonroot. ${WORKDIR}
USER 10000:10001
WORKDIR ${WORKDIR}

ENTRYPOINT ["/usr/bin/tini", "--"]

