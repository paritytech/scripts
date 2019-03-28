# triggers image autoupdate with the new Rust stable release
FROM rust:stretch AS builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-build" \
	description="This is for CI build stage for Parity Ethereum linux binary." \
	url="https://gitlab.com/paritytech/scripts" \
	vcs-url="/scripts/docker-files-for-Gitlab-CI-rust/cross/andriod"

RUN set -eux; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		git cmake ca-certificates g++ rhash \
		libudev-dev time unzip xsltproc gperf; \
# removed:
# wget curl
# sudo file build-essential bison flex lib32stdc++6 lib32z1 python
# autotools-dev automake autoconf libtool docbook-xsl
	rustup target add arm-linux-androideabi; \
	rustup target add armv7-linux-androideabi; \
# Android NDK and toolchain
	cd /usr/local; \
    wget -q https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip; \
    echo "> finished downloading"; \
    unzip -qo android-ndk-r16b-linux-x86_64.zip; \
    echo "> finished unzipping"; \
    rm -f android-ndk-r16b-linux-x86_64.zip
ENV NDK_HOME=/usr/local/android-ndk-r16b \
	ANDROID_NDK=/usr/local/android-ndk-r16b
RUN /usr/local/android-ndk-r16b/build/tools/make-standalone-toolchain.sh \
    --arch=arm --install-dir=/opt/ndk-standalone --stl=libc++ --platform=android-26
ENV PATH=$PATH:/opt/ndk-standalone/bin

# Compiling libudev for Android
# This is the most hacky part of the process, as we need to apply a patch and pass specific
# options that the compiler environment doesn't define.
RUN cd /root; \
    git clone https://github.com/gentoo/eudev.git
ADD libudev.patch /root
RUN cd /root/eudev; \
    git checkout 83d918449f22720d84a341a05e24b6d109e6d3ae; \
    ./autogen.sh; \
    ./configure  \
		--disable-introspection --disable-programs --disable-hwdb \
		--host=arm-linux-androideabi --prefix=/opt/ndk-standalone/sysroot/usr/ \
		--enable-shared=false CC=arm-linux-androideabi-clang \
		CFLAGS="-D LINE_MAX=2048 -D RLIMIT_NLIMITS=15 -D IPTOS_LOWCOST=2 -std=gnu99" \
		CXX=arm-linux-androideabi-clang++; \
    git apply - < /root/libudev.patch; \
    make; \
    make install; \
	rm -rf /root/eudev; \
	rm /root/libudev.patch

# Rust-related configuration
ADD config /.cargo/config
ENV ARM_LINUX_ANDROIDEABI_OPENSSL_DIR=/opt/ndk-standalone/sysroot/usr \
	ARMV7_LINUX_ANDROIDEABI_OPENSSL_DIR=/opt/ndk-standalone/sysroot/usr \
	CC_arm_linux_androideabi=arm-linux-androideabi-clang \
	CC_armv7_linux_androideabi=arm-linux-androideabi-clang \
	CXX_arm_linux_androideabi=arm-linux-androideabi-clang++ \
	CXX_armv7_linux_androideabi=arm-linux-androideabi-clang++ \
	AR_arm_linux_androideabi=arm-linux-androideabi-ar \
	AR_armv7_linux_androideabi=arm-linux-androideabi-ar \
	CFLAGS_arm_linux_androideabi="-std=gnu11 -fPIC -D OS_ANDROID" \
	CFLAGS_armv7_linux_androideabi="-std=gnu11 -fPIC -D OS_ANDROID" \
	CXXFLAGS_arm_linux_androideabi="-std=gnu++11 -fPIC -fexceptions -frtti -static-libstdc++ -D OS_ANDROID" \
	CXXFLAGS_armv7_linux_androideabi="-std=gnu++11 -fPIC -fexceptions -frtti -static-libstdc++ -D OS_ANDROID" \
	CXXSTDLIB_arm_linux_androideabi="" \
	CXXSTDLIB_armv7_linux_androideabi="" \
	CC=gcc \
	CXX=g++ \
# show backtraces
	RUST_BACKTRACE=1

WORKDIR /builds/parity/parity-ethereum/
