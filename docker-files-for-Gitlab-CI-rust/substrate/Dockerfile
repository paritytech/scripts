FROM parity/rust:gitlab-ci as builder 
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

# install tools and dependencies

RUN git clone https://github.com/paritytech/substrate.git
RUN pwd
RUN cd substrate && cargo build --release
RUN pwd

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*

FROM phusion/baseimage:0.10.0
MAINTAINER Parity Technologies <devops@parity.io>
ARG PROFILE=release
COPY --from=builder /build/substrate/target/release/substrate /usr/local/bin

RUN mv /usr/share/ca* /tmp && \
        rm -rf /usr/share/*  && \
        mv /tmp/ca-certificates /usr/share/ && \
        rm -rf /usr/lib/python* && \
        mkdir -p /root/.local/share/Polkadot && \
        ln -s /root/.local/share/Polkadot /data


EXPOSE 30333 9933 9944
VOLUME ["/data"]

CMD ["/usr/local/bin/substrate"]

