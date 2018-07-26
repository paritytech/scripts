FROM ubuntu:xenial
MAINTAINER Parity Technologies <devops@parity.io>

WORKDIR /build

RUN apt update&& \
  apt install -y --no-install-recommends \
  curl ca-certificates file build-essential wget git g++ cmake pkg-config bison flex rhash\
  unzip lib32stdc++6 lib32z1 python autotools-dev automake autoconf libtool \
  gperf xsltproc docbook-xsl

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# set cargo target
ENV RUST_TARGETS armv7-linux-androideabi
ENV TARGET armv7-linux-androideabi

# install aarch64 toolchain
RUN rustup target add armv7-linux-androideabi

# Android NDK and toolchain
RUN cd /usr/local && \
    wget -q https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip && \
    unzip -q android-ndk-r16b-linux-x86_64.zip && \
    rm android-ndk-r16b-linux-x86_64.zip
ENV NDK_HOME /usr/local/android-ndk-r16b
RUN /usr/local/android-ndk-r16b/build/tools/make-standalone-toolchain.sh \
    --arch=arm --install-dir=/opt/ndk-standalone --stl=libc++ --platform=android-26
ENV PATH $PATH:/opt/ndk-standalone/bin

# Compiling OpenSSL for Android

RUN cd /root && \
    git clone git://git.openssl.org/openssl.git && \
    cd openssl && \
    git checkout OpenSSL_1_1_0-stable
ENV CROSS_SYSROOT /opt/ndk-standalone/sysroot
RUN cd /root/openssl && \
    ./Configure android-armeabi --cross-compile-prefix=arm-linux-androideabi- \
    -static no-stdio no-ui \
    -I/usr/local/android-ndk-r16b/sysroot/usr/include \
    -I/usr/local/android-ndk-r16b/sysroot/usr/include/arm-linux-androideabi \
    -L/usr/local/android-ndk-r16b/sysroot/usr/lib \
    --prefix=/opt/ndk-standalone/sysroot/usr
RUN cd /root/openssl && \
    make build_libs && \
    make install_dev
RUN rm -rf /root/openssl

# Compiling libudev for Android
# This is the most hacky part of the process, as we need to apply a patch and pass specific
# options that the compiler environment doesn't define.
RUN cd /root && \
    git clone https://github.com/gentoo/eudev.git
ADD libudev.patch /root
RUN cd /root/eudev && \
    git checkout 83d918449f22720d84a341a05e24b6d109e6d3ae && \
    ./autogen.sh && \
    ./configure --disable-introspection --disable-programs --disable-hwdb \
                --host=arm-linux-androideabi --prefix=/opt/ndk-standalone/sysroot/usr/ \
                --enable-shared=false CC=arm-linux-androideabi-clang \
                CFLAGS="-D LINE_MAX=2048 -D RLIMIT_NLIMITS=15 -D IPTOS_LOWCOST=2 -std=gnu99" \
                CXX=arm-linux-androideabi-clang++ && \
    git apply - < /root/libudev.patch && \
    make && \
    make install
RUN rm -rf /root/eudev
RUN rm /root/libudev.patch

# set cross compile ENV
ENV CC arm-linux-androideabi-clang
ENV CXX arm-linux-androideabi-clang++
ENV ARMV7_LINUX_ANDROIDEABI_OPENSSL_DIR /opt/ndk-standalone/sysroot/usr
ENV CC_armv7_linux_androideabi arm-linux-androideabi-clang
ENV CXX_armv7_linux_androideabi arm-linux-androideabi-clang++
ENV AR_armv7_linux_androideabi arm-linux-androideabi-ar
ENV CFLAGS_armv7_linux_androideabi -std=gnu11 -fPIC -D OS_ANDROID
ENV CXXFLAGS_armv7_linux_androideabi -std=gnu++11 -fPIC -fexceptions -frtti -static-libstdc++ -D OS_ANDROID
RUN ln -sf /opt/ndk-standalone/bin/arm-linux-androideabi-strip /usr/bin/strip
ENV HOST_CC gcc
ENV HOST_CXX g++
ENV RUSTFLAGS -C link-arg=-lc++_static -C link-arg=-lc++abi -C link-arg=-landroid_support


# show backtraces
ENV RUST_BACKTRACE 1

# cleanup
RUN apt autoremove -y
RUN apt clean -y
RUN rm -rf /tmp/* /var/tmp/*
