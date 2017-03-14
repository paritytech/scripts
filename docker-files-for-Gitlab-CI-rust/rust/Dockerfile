FROM ethcore/rustup:latest
MAINTAINER Parity Technologies <devops@parity.io>

# Pass a channel (i.e., stable, beta, nightly)
# as in `$ docker build --build-arg channel=stable ...`.
ARG channel=none
# Pick a rust from specified channel
RUN rustup update $channel
RUN rustup default $channel
#add covarage
RUN if ([ "$channel" = "stable" ]); then \
      apt-get install -y --force-yes --no-install-recommends \
      wget cmake binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev &&\
      wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz &&\
      tar xzf master.tar.gz &&\
      mkdir -p kcov-master/build &&\
      cd kcov-master/build &&\
      cmake .. &&\
      make && make install &&\
      cd ; fi
#ENV KCOV_CMD "./kcov-master/tmp/usr/local/bin/kcov"
#ENV PATH /build/kcov-master/tmp/usr/local/bin/kcov:$PATH

