

FROM ubuntu:latest

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=paritytech

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/musl-ci-linux" \
    io.parity.image.description=" \
rust target x86_64-unknown-linux-musl, openssl, zlib, musl tools clang" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/musl-linux/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/musl-ci-linux/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

ARG TARGET=x86_64-linux-musl
WORKDIR /builds


# config for x86_64-unknown-linux-musl
COPY utility/musl-ci-linux-config /root/.cargo/config


ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH \
		CC=clang \
		CXX=clang
# install tools and dependencies
RUN set -eux; \
    apt -y update; \
    DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    gpg dirmngr gpg-agent libssl-dev clang lld libclang-dev make cmake \
    git pkg-config curl time rhash ca-certificates; \

# set a link to clang
#        update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
# install rustup, use minimum components
    curl -L "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
    -o rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable; \
    rm rustup-init; \
    chmod -R a+w ${RUSTUP_HOME} ${CARGO_HOME}; \
    rustup install nightly; \
    rustup target add x86_64-unknown-linux-musl; \
    rustup target add x86_64-unknown-linux-musl --toolchain nightly; \
    rustup target add wasm32-unknown-unknown; \
    rustup target add wasm32-unknown-unknown --toolchain nightly; \
# install sccache
# cargo install sccache --features redis; \
# FIXME: TEMPORARY OVERRIDE due to the sccache issue
# https://github.com/mozilla/sccache/issues/663
  	cargo install --git https://github.com/mozilla/sccache  --rev 6628e1f70db3d583cb5e79210603ad878de3d315 --features redis; \
# versions
  	rustup show; \
  	cargo --version; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
    	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache;
#    cargo install --git https://github.com/mozilla/sccache  --rev 6628e1f70db3d583cb5e79210603ad878de3d315 --features redis;
#    SCCACHE_LATEST_URL=`curl -sL    https://api.github.com/repos/mozilla/sccache/releases/latest | jq -r '.assets[0].browser_download_url'`; \
#    WASM_PACK_LATEST_URL=`curl -sL https://api.github.com/repos/rustwasm/wasm-pack/releases/latest | jq -r '.assets[3].browser_download_url'`; \
#    WASM_GC_LATEST_URL=`curl -sL https://api.github.com/repos/alexcrichton/wasm-gc/releases/latest | jq -r '.assets[2].browser_download_url'`; \
#    CARGO_WEB_LATEST_URL=`curl -sL https://api.github.com/repos/koute/cargo-web/releases/latest | jq -r '.assets[1].browser_download_url'`; \
#    curl -L $SCCACHE_LATEST_URL | tar zxf - --overwrite --strip-components=1 -C /usr/local/cargo/bin ; \
#    curl -L $WASM_PACK_LATEST_URL | tar zxf - --overwrite --strip-components=1 -C /usr/local/cargo/bin ; \
#    curl -L $WASM_GC_LATEST_URL | tar zxf - --overwrite --strip-components=1 -C /usr/local/cargo/bin; \
#    curl -L $CARGO_WEB_LATEST_URL | gzip -d > /usr/local/cargo/bin/cargo-web; \
#    chmod +x /usr/local/cargo/bin/cargo-web; \


# install latest musl
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

# apt clean up
RUN apt remove --purge gpg dirmngr gpg-agent -y;\
  	apt-get autoremove -y; \
  	apt-get clean; \
  	rm -rf /var/lib/apt/lists/*

# 1. set build ENV
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=$TARGET-gcc \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_GCC=$TARGET-gcc \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_CC=$TARGET-gcc \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_CXX=$TARGET-g++ \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_AR=$TARGET-ar \
    CC=$TARGET-gcc \
    CXX=$TARGET-g++ \
    AR=$TARGET-ar \
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
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/$TARGET/lib:$LD_LIBRARY_PATH \
    PKG_CONFIG_ALLOW_CROSS=1 \
    PKG_CONFIG_ALL_STATIC=1 \
    PORTABLE=1 \
    RUST_BACKTRACE=1 \
    RUSTC_WRAPPER=sccache

# Set up a prefix for musl build libraries, make the linker's job of finding them easier
RUN echo "/usr/local/lib" >> /etc/ld-musl-x86_64.path; \
    echo "/usr/local/x86_64-linux-musl/lib" >> /etc/ld-musl-x86_64.path; \
    ln -s /usr/include/x86_64-linux-gnu/asm /usr/local/x86_64-linux-musl/include/asm; \
    ln -s /usr/include/asm-generic /usr/local/x86_64-linux-musl/include/asm-generic; \
    ln -s /usr/include/ /usr/local/x86_64-linux-musl/include
