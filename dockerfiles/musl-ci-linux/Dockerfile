ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/musl-ci-linux" \
    io.parity.image.description="Inherits from base-ci-linux:latest. \
rust target x86_64-unknown-linux-musl, openssl, zlib, musl tools" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/musl-linux/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/musl-ci-linux/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

ARG TARGET=x86_64-linux-musl

# install tools and dependencies
RUN rustup target add x86_64-unknown-linux-musl; \
    rustup target add x86_64-unknown-linux-musl --toolchain nightly
RUN set -eux; \
    apt -y update; \
    apt install -y --no-install-recommends \
    gpg dirmngr gpg-agent;

# config for x86_64-unknown-linux-musl
COPY utility/musl-ci-linux-config /root/.cargo/config

# install musl
RUN set -eux;\
    curl -fSL "https://more.musl.cc/x86_64-linux-musl/x86_64-linux-musl-cross.tgz" -o x86_64-linux-musl-cross.tgz; \
    curl -fSL "https://more.musl.cc/x86_64-linux-musl/x86_64-linux-musl-cross.tgz.sig" -o x86_64-linux-musl-cross.tgz.sig; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys BE4BF7E6811C5BA41345C11EB1D0B4566FBBDB40; \
    gpg --batch --verify x86_64-linux-musl-cross.tgz.sig x86_64-linux-musl-cross.tgz; \
    tar xzf x86_64-linux-musl-cross.tgz; \
    cd x86_64-linux-musl-cross; \
    cp -fR * ../../usr/local/; \
    cd ..&& rm -rf x86_64-linux-musl-cross*

# 1. set build ENV
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=$TARGET-gcc \
    CC=$TARGET-gcc \
    CXX=$TARGET-g++ \
    CC_x86_64-unknown-linux-gnu=$TARGET-gcc \
    CXX_x86_64-unknown-linux-gnu=$TARGET-g++ \
    CC_x86_64_unknown_linux_musl=$TARGET-gcc \
    CXX_x86_64_unknown_linux_musl=$TARGET-g++ \
    TARGET_CC=$TARGET-gcc \
    TARGET_CXX=$TARGET-g++ \
    TARGET_AR=$TARGET-ar \
    TARGET_C_INCLUDE_PATH=/usr/local/$TARGET/include/ \
    CXX_LIB_PATH_x86_64_unknown_linux_musl=/usr/local/$TARGET/lib/ \
    C_LIB_PATH_x86_64_unknown_linux_musl=/usr/local/$TARGET/lib/ \
    CXXSTDLIB=stdc++ \
    TARGET_CXXSTDLIB=stdc++ \
    CXXSTDLIB_x86_64_unknown_linux_musl=stdc++ \
    PATH=/usr/local/x86_64-unknown-linux-musl/bin:$PATH \
    LDFLAGS_x86_64_unknown_linux_gnu=" -static -static-libstdc++ -static-libgcc -L/usr/local/lib -L/usr/local/$TARGET/lib" \
    LDFLAGS_x86_64_unknown_linux_musl=" -static -static-libstdc++ -static-libgcc -L/usr/local/lib -L/usr/local/$TARGET/lib" \
    LDFLAGS=" -static -static-libstdc++ -static-libgcc -L/usr/local/lib -L/usr/local/$TARGET/lib" \
    CFLAGS_x86_64_unknown_linux_gnu=" -fPIC  -I/usr/local/include -I/usr/local/$TARGET/include" \
    CXXFLAGS_x86_64_unknown_linux_gnu=" -fPIC -I/usr/local/include -I/usr/local/$TARGET/include" \
    CFLAGS_x86_64_unknown_linux_musl=" -fPIC  -I/usr/local/include -I/usr/local/$TARGET/include" \
    CXXFLAGS_x86_64_unknown_linux_musl=" -fPIC -I/usr/local/include -I/usr/local/$TARGET/include" \
    CFLAGS=" -fPIC  -I/usr/local/include -I/usr/local/$TARGET/include" \
    CXXFLAGS=" -fPIC -I/usr/local/include -I/usr/local/$TARGET/include" \
    LIBZ_SYS_STATIC=1 \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/$TARGET/lib:$LD_LIBRARY_PATH \
    PKG_CONFIG_ALLOW_CROSS=1 \
    PKG_CONFIG_ALL_STATIC=1 \
    OPENSSL_STATIC=1

# Set up a prefix for musl build libraries, make the linker's job of finding them easier
RUN echo "/usr/local/lib" >> /etc/ld-musl-x86_64.path; \
    echo "/usr/local/x86_64-linux-musl/lib" >> /etc/ld-musl-x86_64.path; \
    ln -s /usr/include/x86_64-linux-gnu/asm /usr/local/x86_64-linux-musl/include/asm; \
    ln -s /usr/include/asm-generic /usr/local/x86_64-linux-musl/include/asm-generic; \
    ln -s /usr/include/ /usr/local/x86_64-linux-musl/include

# Build static zlib and openssl
RUN export CC=$TARGET_CC; \
    export C_INCLUDE_PATH=$TARGET_C_INCLUDE_PATH; \
    echo "Building zlib"; \
    VERS=1.2.11; \
    ZLIB_SHA256="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"; \
    curl -fSL "https://zlib.net/zlib-$VERS.tar.gz" -o zlib-$VERS.tar.gz; \
    echo "$ZLIB_SHA256 zlib-$VERS.tar.gz" | sha256sum -c -; \
    tar xzf zlib-$VERS.tar.gz; \
    cd zlib-$VERS; \
    ./configure --static --archs="-fPIC" --prefix=/usr/local/$TARGET; \
    make && make install; \
    cd .. && rm -rf zlib-$VERS.tar.gz zlib-$VERS checksums.txt ; \
    echo "Building OpenSSL"; \
    VERS=1.1.1g; \
    OPENSSL_SHA256="ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46"; \
    curl -fSL "https://www.openssl.org/source/openssl-$VERS.tar.gz" -o openssl-$VERS.tar.gz; \
    echo "$OPENSSL_SHA256 openssl-$VERS.tar.gz" | sha256sum -c -; \
    tar xzf openssl-$VERS.tar.gz && cd openssl-$VERS; \
    ./Configure linux-x86_64 no-async no-afalgeng no-shared no-zlib no-engine no-unit-test --static -fPIC --prefix=/usr/local/$TARGET; \
    make depen; \
    make && make install; \
    cd .. && rm -rf openssl-$VERS.tar.gz openssl-$VERS checksums.txt /usr/local/$TARGET/share

#apt cleanup
RUN apt remove --purge -y gpg gpg-agent dirmngr; \
  apt autoremove -y; \
  apt clean; \
  rm -rf /var/lib/apt/lists/*;

# 2. set build ENV
ENV OPENSSL_DIR=/usr/local/musl/$TARGET/ \
    OPENSSL_INCLUDE_DIR=/usr/local/$TARGET/include/ \
    DEP_OPENSSL_INCLUDE=/usr/local/$TARGET/include/ \
    OPENSSL_LIB_DIR=/usr/local/$TARGET/lib/ \
    PORTABLE=1
