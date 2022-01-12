ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

FROM ${REGISTRY_PATH}/ci-linux:production

LABEL summary="Image for Substrate-api-sidecar benchmarks" \
	name="${REGISTRY_PATH}/sidecar-bench" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Inherits from base-ci-linux; \
wasm-gc, wasm-bindgen-cli, wasm-pack, cargo-audit, cargo-web, cargo-deny" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/sidecar-bench/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/sidecar-bench/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN set -eux && \
    apt-get update && \
    apt-get install -y build-essential git clang libclang-dev pkg-config libssl-dev unzip lua5.1 liblua5.1-0-dev && \
    # install npm and substrate/api-sidecar
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    npm install --global @substrate/api-sidecar && \
    # install luarocks
    curl -L https://luarocks.org/releases/luarocks-3.3.1.tar.gz -o ./luarocks-3.3.1.tar.gz && \
    tar zxpf luarocks-3.3.1.tar.gz && \
    cd ./luarocks-3.3.1 && \
    ./configure && \
    make bootstrap && \
    cd .. && rm -rf luarocks-3.3.1/ && \
    # install wrk
    git clone https://github.com/wg/wrk.git wrk && \
    cd wrk && \
    make && \
    cp wrk /usr/local/bin && \
    cd .. && \
    # cleanup
    apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
