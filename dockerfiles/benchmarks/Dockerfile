ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/library/python:slim

# metadata
LABEL summary="Image for benchmarks" \
	name="${REGISTRY_PATH}/benchmarks" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Image to push benchmarks and evaluate them" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/benchmarks/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/benchmarks/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

COPY benchmarks/check_bench_result.py /usr/local/bin/check_bench_result
COPY benchmarks/push_bench_result.py /usr/local/bin/push_bench_result

RUN groupadd -g 10000 nonroot; \
    useradd -u 10000 -g 10000 -s /bin/bash -m nonroot; \
    mkdir /nonroot;\
    chown nonroot. /nonroot

USER nonroot:nonroot

WORKDIR /nonroot

COPY benchmarks/requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt
