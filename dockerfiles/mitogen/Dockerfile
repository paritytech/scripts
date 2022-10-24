FROM docker.io/library/python:3.9-slim-buster

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

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
    sshpass ssh rsync tini curl git ruby \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir ansible==5.10 google-auth requests jmespath

RUN  curl -fSL -o /usr/local/bin/subkey 'https://releases.parity.io/substrate/x86_64-debian%3Astretch/v3.0.0/subkey/subkey' \
     && chmod +x /usr/local/bin/subkey

ENV ANSIBLE_STRATEGY=mitogen_linear
ENV ANSIBLE_STRATEGY_PLUGINS=/opt/mitogen/ansible_mitogen/plugins/strategy
RUN  cd /opt && git clone --depth 1 --branch v0.3.3 https://github.com/mitogen-hq/mitogen.git

# TODO: switch to non-root here after 'FF_DISABLE_UMASK_FOR_DOCKER_EXECUTOR' is properly set in gitlab ci

ENTRYPOINT ["/usr/bin/tini", "--"]

