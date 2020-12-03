FROM ubuntu:groovy

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

# metadata
LABEL summary="CI image with all dependencies for sccache compilation." \
	name="${REGISTRY_PATH}/sccache-ci-linux" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="libssl-dev, clang, libclang-dev, lld, cmake, make, git, pkg-config \
curl, time, rhash, rust stable, rust nightly, sccache" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/sccache-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/sccache-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

# config for wasm32-unknown-unknown & clang
COPY utility/base-ci-linux-config /root/.cargo/config

ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:/usr/local/cuda-11.1/bin:$PATH \
	CC=clang \
	CXX=clang \
    LD_LIBRARY_PATH=/usr/local/cuda-11.1/lib64 \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		linux-headers-5.8.0-29 libssl-dev clang libclang-dev gcc binutils coreutils gdbserver \
        zlib1g-dev librust-zip+deflate-miniz-dev curl gnupg2 docker \
        lld make cmake git pkg-config time rhash ca-certificates; \
# setup nvcc
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add -; \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cuda-command-line-tools-11-1=11.1.1-1; \
    ln -s cuda-11.1 /usr/local/cuda; \
# set a link to clang
	update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
# install rustup, use minimum components
	curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" -o rustup-init; \
  	chmod +x rustup-init; \
  	./rustup-init -y --no-modify-path --profile minimal --default-toolchain nightly --component clippy rustfmt; \
  	rm rustup-init; \
  	chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}; \
    rustup toolchain install stable --profile minimal; \
# install sccache
	# cargo install sccache --features redis; \
	# FIXME: TEMPORARY OVERRIDE due to the sccache issue
	# https://github.com/mozilla/sccache/issues/663
	cargo install --git https://github.com/mozilla/sccache  --rev 6628e1f70db3d583cb5e79210603ad878de3d315 --features redis; \
    cargo install broot ripgrep sd; \
# versions
	rustup show; \
	cargo --version; \
    nvcc --version; \
	gcc --version; \
	clang --version; \
	gdbserver --version; \
	openssl version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
# cache handler
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
  	RUST_BACKTRACE=1

CMD ["bash", "-l"]
