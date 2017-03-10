FROM alpine:edge
MAINTAINER Denis S. Soldatov aka General-Beck <general-beck@ethcore.io>

# install tools and dependencies
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk add --no-cache --update alpine-sdk git curl wget python nodejs file openssl pkgconfig eudev\
RUN rm -rf /var/cache/apk/*
ENV USER root
#ENV SHELL /bin/bash
# Define bash as default command 
CMD ["/bin/bash"]
# install rustup 
#RUN set -ex
#RUN mkdir .rust
#RUN cd .rust
#RUN wget https://static.rust-lang.org/dist/rust-1.15.1-x86_64-unknown-linux-gnu.tar.gz
#RUN tar xf rust-1.15.1-x86_64-unknown-linux-gnu.tar.gz
#RUN mv rust-1.15.1-x86_64-unknown-linux-gnu rust
#ENV LD_LIBRARY_PATH=~/opt/rust/rustc/lib:$LD_LIBRARY_PATH
#ENV PATH=.rust/rust/rustc/bin:$PATH
#ENV PATH=.rust/rust/cargo/bin:$PATH
RUN curl -sL https://static.rust-lang.org/rustup.sh -o rustup.sh
RUN sudo sh rustup.sh --prefix=~/rust --spec=stable -y --disable-sudo
#&&curl https://sh.rustup.rs -sSf | sh --verbose
#RUN export LD_LIBRARY_PATH="~/root/lib:$LD_LIBRARY_PATH"
#RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --disable-sudo --prefix=~/root --disable-ldconfig
ENV USER root
ENV PATH /root/.cargo/bin:$PATH
ENV LD_LIBRARY_PATH=/root/lib:$LD_LIBRARY_PATH
#RUN cd /root/&&ls
#RUN curl -sf https://static.rust-lang.org/rustup.sh | sudo sh
#ENV LD_LIBRARY_PATH ~/opt/rust/rustc/lib:$LD_LIBRARY_PATH
#ENV PATH ~/.rust/rust/rustc/bin:$PATH
#RUN curl https://sh.rustup.rs -sSf | sudo sh
#RUN curl -sSf https://static.rust-lang.org/rustup.sh -o rustup.sh &&\ 
#     sudo /bin/bash rustup.sh --channel=stable --verbose
# install aws cli
#RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
#    python get-pip.py &&\
#    pip install awscli
#VOLUME ["/build"]
#WORKDIR "/build"
#ENV cargo  ~/.cargo/bin 
RUN cargo -V
RUN rustc -V
RUN git clone https://github.com/ethcore/parity
RUN cd parity
RUN cargo build --release
