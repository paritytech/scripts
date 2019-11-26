# triggers image autoupdate with the new Rust stable release
FROM rust:stretch

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="registry.parity.io/parity/infrastructure/scripts/parity-ci-android" \
	io.parity.image.description="cmake rhash libudev-dev time xsltproc gperf clang-8 libc6-dev-i386 wget unzip; \
	libudev.patch; android ndk r16b; cargo target arm-linux-androideabi, cargo target armv7-linux-androideabi; sccache" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-android/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/parity-ci-android/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

COPY libudev.patch /root/
COPY config /.cargo/

# Android NDK configurations
ENV NDK_HOME=/usr/local/android-ndk-r16b \
	ANDROID_NDK=/usr/local/android-ndk-r16b \
	PATH=$PATH:/opt/ndk-standalone/bin \
# compiler ENV
	ARM_LINUX_ANDROIDEABI_OPENSSL_DIR=/opt/ndk-standalone/sysroot/usr \
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
	CXX=g++

# install tools and dependencies
COPY clang8.key /etc/apt/trusted.gpg.d/debian-archive-jessie-automatic.gpg
RUN set -eux; \
echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" \
	> /etc/apt/sources.list.d/llvm.list; \
echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" \
	>> /etc/apt/sources.list.d/llvm.list; \
DEBIAN_FRONTEND=noninteractive apt-get -y update; \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
# libssl-dev is needed for cargo-audit and sccache
		g++ gcc libssl-dev clang-8 libc6-dev-i386\
		make cmake libudev-dev ca-certificates \
		git pkg-config curl time rhash xsltproc gperf; \
# set a link to clang-8
	ln -s /usr/bin/clang-8 /usr/bin/clang; \
	rustup target add arm-linux-androideabi; \
	rustup target add armv7-linux-androideabi; \
	cargo install sccache --features redis; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
# cargo clean up
# removes compilation artifacts cargo install creates (>250M)
	rm -rf $CARGO_HOME/registry; \
# removes toolchain's html docs and autocompletions (>300M for each toolchain)
	rm -rf /usr/local/rustup/toolchains/*/share; \
# Android NDK and toolchain
	cd /usr/local; \
	wget -q https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip; \
	echo "> finished downloading"; \
	unzip -qo android-ndk-r16b-linux-x86_64.zip; \
	echo "> finished unzipping"; \
	rm -f android-ndk-r16b-linux-x86_64.zip; \
	/usr/local/android-ndk-r16b/build/tools/make-standalone-toolchain.sh \
		--arch=arm --install-dir=/opt/ndk-standalone --stl=libc++ --platform=android-26; \
# Compiling libudev for Android
# This is the most hacky part of the process, as we need to apply a patch and
# pass specific options that the compiler environment doesn't define.
	cd /root; \
	git clone https://github.com/gentoo/eudev.git; \
# ADD libudev.patch /root
	cd /root/eudev; \
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

# cache handlers
ENV	RUSTC_WRAPPER=sccache \
# show backtraces
	RUST_BACKTRACE=1

WORKDIR /builds
