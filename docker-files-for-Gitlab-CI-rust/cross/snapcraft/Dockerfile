FROM ubuntu:18.04
MAINTAINER Parity Technologies <devops@parity.io>
# install tools and dependencies
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y --no-install-recommends \
    snapcraft git snapd ca-certificates file python \
    zip curl expect gettext-base nodejs cmake rhash \
    wget
RUN wget http://security.ubuntu.com/ubuntu/pool/universe/s/snapcraft/snapcraft_2.43.1_all.deb
RUN dpkg -i snapcraft_2.43.1_all.deb
RUN apt-get clean

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
