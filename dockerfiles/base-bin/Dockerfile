FROM docker.io/library/ubuntu:22.04

# metadata
ARG VCS_REF
ARG BUILD_DATE
ARG GPG_KEYSERVER="keyserver.ubuntu.com"
ARG PARITY_SEC_GPGKEY=9D4B2B6EB8F97156D19669A9FF0812D491B96798
ARG DOC_URL=https://github.com/paritytech/polkadot
ARG USER=parity

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/base-bin" \
	io.parity.image.description="A base image for standard binary distribution" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/base-bin/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="${DOC_URL}"

# show backtraces
ENV RUST_BACKTRACE 1

# install tools and dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		libssl3 ca-certificates gnupg && \
	useradd -m -u 1000 -U -s /bin/sh -d /${USER} ${USER} && \
# add repo's gpg keys and install the published polkadot binary
	gpg --keyserver ${GPG_KEYSERVER} --recv-keys ${PARITY_SEC_GPGKEY} && \
	gpg --export ${PARITY_SEC_GPGKEY} > /usr/share/keyrings/parity.gpg && \
	echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list && \
	apt-get update && \
# apt cleanup
	apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* ; \
	mkdir -p /data /${USER}/.local/share && \
	chown -R ${USER}:${USER} /data /${USER} && \
	ln -s /data /${USER}/.local/share/${USER}

# Set last update
ENV TMSP=/var/lastupdate
RUN	mkdir -p $(dirname $TMSP); date > $TMSP; chmod a+r $TMSP

USER ${USER}
