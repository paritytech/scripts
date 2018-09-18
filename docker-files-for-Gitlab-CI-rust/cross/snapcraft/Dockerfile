FROM ubuntu:16.04
MAINTAINER Parity Technologies <devops@parity.io>
#WORKDIR /build
# Enable multiverse as snapcraft cleanbuild does.
#RUN sed -i 's/ universe/ universe multiverse/' /etc/apt/sources.list
# install tools and dependencies
RUN apt-get update && \
        apt-get dist-upgrade --yes && \
	apt-get install --yes --no-install-recommends \
        snapcraft \
        git \
        snapd \
        ca-certificates \
        file \
        python \
        zip \
        curl \
        expect \
        gettext-base \
        nodejs \
        cmake \
        wget && \
	wget http://security.ubuntu.com/ubuntu/pool/universe/s/snapcraft/snapcraft_2.43.1_all.deb &&\
	dpkg -i snapcraft_2.43.1_all.deb &&\
	apt-get clean

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
