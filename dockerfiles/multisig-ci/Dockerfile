FROM docker.io/library/python:buster

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/multisig-ci" \
	io.parity.image.description="python, poetry " \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/multisig-ci/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/multisig-ci/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
	chmod +x kubectl && \
	mv kubectl /usr/local/bin/ && \
	apt-get update && apt-get --no-install-recommends install -y gettext python3-setuptools && \
	pip install poetry==1.8.3 && \
	# add non-root user
	groupadd -g 10000 nonroot && \
	useradd -u 10000 -g 10000 -s /bin/bash -m nonroot

USER nonroot:nonroot
