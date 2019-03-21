FROM parity/rust-parity-ethereum-build:xenial as builder

# metadata
# LABEL maintainer="devops-team@parity.io" \
# 	vendor="Parity Technologies" \
# 	name="parity/rust-parity-ethereum-build" \
# 	description="This is for CI build stage for Parity Ethereum linux binary." \
# 	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
# 	url="https://gitlab.com/paritytech"

WORKDIR /build/parity/substrate

# clone repo and build executable
RUN git clone https://github.com/paritytech/substrate.git . \
	cargo build --release

FROM phusion/baseimage:0.10.0
# metadata
# LABEL maintainer="devops-team@parity.io" \
# 	vendor="Parity Technologies" \
# 	name="parity/rust-parity-ethereum-build" \
# 	description="This is for CI build stage for Parity Ethereum linux binary." \
# 	vcs-url="https://gitlab.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-ci" \
# 	url="https://gitlab.com/paritytech"
ARG PROFILE=release
COPY --from=builder /build/parity/substrate/target/release/substrate /usr/local/bin

RUN mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	rm -rf /usr/lib/python* && \
	mkdir -p /root/.local/share/Polkadot && \
	ln -s /root/.local/share/Polkadot /data


EXPOSE 30333 9933 9944
VOLUME ["/data"]

CMD ["/usr/local/bin/substrate"]

