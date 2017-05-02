FROM ethcore/rustup:latest
MAINTAINER Parity Technologies <devops@parity.io>

# Pass a channel (i.e., stable, beta, nightly)
# as in `$ docker build --build-arg channel=stable ...`.
ARG channel=none
# Pick a rust from specified channel
RUN rustup update $channel
RUN rustup default $channel
