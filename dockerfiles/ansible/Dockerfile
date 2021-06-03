FROM docker.io/library/python:3.9-slim-buster

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
        io.parity.image.vendor="Parity Technologies" \
        io.parity.image.title="${REGISTRY_PATH}/ansible" \
        io.parity.image.description="ansible" \
        io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ansible/Dockerfile" \
        io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ansible/README.md" \
        io.parity.image.revision="${VCS_REF}" \
        io.parity.image.created="${BUILD_DATE}"

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass ssh rsync tini curl

RUN pip install pip --upgrade
RUN pip install ansible
RUN ansible-galaxy collection install ansible.posix

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

