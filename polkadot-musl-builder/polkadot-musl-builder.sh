#!/usr/bin/env bash

set -eu -o pipefail
shopt -s inherit_errexit

# TODO: It would be cleaner to move all the definitions to command-line
# arguments instead of having them in environment variables


## -- POLKADOT-RELATED DEFINITIONS
POLKADOT_REPO="${POLKADOT_REPO:-https://github.com/paritytech/polkadot}"

# POLKADOT_BRANCH can also be a tag instead of a branch name
# This is defaulting to v0.9.9-1 at the moment because the setup needs to be
# adjusted for the migration to tikv-jemalloc-sys
# (https://github.com/paritytech/polkadot/pull/3897)
POLKADOT_BRANCH="${POLKADOT_BRANCH:-v0.9.9-1}"


## -- MISC DEFINITIONS

VERBOSE="${VERBOSE:-false}"

TARGET="${TARGET:-x86_64-linux-musl}"
RUST_TARGET="${RUST_TARGET:-x86_64-unknown-linux-musl}"
HOST="${HOST:-x86_64-linux-gnu}"

DEBIAN_FRONTEND=noninteractive
APT_INSTALL="${APT_INSTALL:-apt install --assume-yes --quiet --no-install-recommends}"
PKG_CONFIG_ALL_STATIC="${PKG_CONFIG_ALL_STATIC:-true}"
PKG_CONFIG_ALLOW_CROSS="${PKG_CONFIG_ALLOW_CROSS:-true}"

GCC_MAJOR_VERSION="${GCC_MAJOR_VERSION:-9}"
GCC_MINOR_VERSION="${GCC_MINOR_VERSION:-2.0}"
GCC_VERSION="$GCC_MAJOR_VERSION.$GCC_MINOR_VERSION"

ZLIB_VERSION="${ZLIB_VERSION:-1.2.11}"
ZLIB_SHA256SUM="${ZLIB_SHA256SUM:-c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1}"

OPENSSL_VERSION="${OPENSSL_VERSION:-1.0.2u}"
OPENSSL_SHA256SUM="${OPENSSL_SHA256SUM:-ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16}"
OPENSSL_ARCH="${OPENSSL_ARCH:-linux-x86_64}"

CROSS_MAKE_VERSION="${CROSS_MAKE_VERSION:-0.9.9}"
CROSS_MAKE_SHA256SUM="${CROSS_MAKE_SHA256SUM:-6cbe2f6ce92e7f8f3973786aaf0b990d0db380c0e0fc419a7d516df5bb03c891}"

MUSL=/usr/local/musl
TARGET_HOME="$MUSL/$TARGET"

# -- JEMALLOC-RELATED DEFINITIONS

LIBUNWIND_VERSION="${LIBUNWIND_VERSION:-1.5}"
LIBUNWIND_SHA256SUM="${LIBUNWIND_SHA256SUM:-c1353c2cd3c55d324d725e705417d3f60f5c1adfa5536aa17fdaf077fb88fbbf}"

JEMALLOC_VERSION="${JEMALLOC_VERSION:-5.2.1}"
JEMALLOC_SHA256SUM="${JEMALLOC_SHA256SUM:-34330e5ce276099e2e8950d9335db5a875689a4c6a56751ef3b1d8c537f887f6}"


# -- ROCKSDB-RELATED DEFINITIONS

# This is the version used for rust-rocksdb v0.17.0
# Should the rust-rocksdb version used by Substrate change, revisit this
ROCKSDB_VERSION="${ROCKSDB_VERSION:-6.20.3}"
ROCKSDB_SHA256SUM="${ROCKSDB_SHA256SUM:-c6502c7aae641b7e20fafa6c2b92273d935d2b7b2707135ebd9a67b092169dca}"

# This is the version used for rust-rocksdb v0.17.0
# Should the rust-rocksdb version used by Substrate change, revisit this
SNAPPY_VERSION="${SNAPPY_VERSION:-1.1.8}"
SNAPPY_SHA256SUM="${SNAPPY_SHA256SUM:-16b677f07832a612b0836178db7f374e414f94657c138e6993cbfc5dcc58651f}"

# This SHA should not matter to much as gflags is only a support library for
# building RocksDB. It does not necessarily needs to be revisited in case the
# RocksDB version changes.
# The following SHA is the latest one from master as of 2021-09-09.
GFLAGS_SHA="${GFLAGS_SHA:-827c769e5fc98e0f2a34c47cef953cc6328abced}"
GFLAGS_SHA256SUM="${GFLAGS_SHA256SUM:-cfdba0f2f17e8b1ff75c98113d5080d8ec016148426abcc19130864e2952d7bd}"


## -- STEPS

install_rust_toolchain() {
  rustup target add "$RUST_TARGET"
  rustup toolchain install --profile minimal nightly
  rustup target add wasm32-unknown-unknown --toolchain nightly
}

install_build_tools() {
  apt update
  $APT_INSTALL curl unzip cmake make build-essential wget pkg-config file
  make --version
  curl --version
  unzip -v
  cmake --version
  wget --version
  pkg-config --version
}

install_musl() {
  local CROSS_MAKE_FOLDER=musl-cross-make-$CROSS_MAKE_VERSION
  local CROSS_MAKE_SOURCE=$CROSS_MAKE_FOLDER.zip

  cd /tmp
  curl -Lsq https://github.com/richfelker/musl-cross-make/archive/v$CROSS_MAKE_VERSION.zip -o $CROSS_MAKE_SOURCE
  echo "$CROSS_MAKE_SHA256SUM $CROSS_MAKE_SOURCE" | sha256sum --check
  unzip -q $CROSS_MAKE_SOURCE
  rm $CROSS_MAKE_SOURCE

  cd $CROSS_MAKE_FOLDER

  # --enable-default-pie: https://www.openwall.com/lists/musl/2017/12/21/1
  #   If you build gcc with --enable-default-pie, musl libc.a will also end up as PIC by default.
  # --enable-initfini-array: https://github.com/richfelker/musl-cross-make/commit/3398364d6e3251cd097024182a8cb9f667c23bda
  echo "
OUTPUT = $MUSL
TARGET = $TARGET
COMMON_CONFIG += CFLAGS=\"-g0 -Os\" CXXFLAGS=\"-g0 -Os\" LDFLAGS=\"-s\"
GCC_CONFIG += --enable-languages=c,c++
GCC_CONFIG += --enable-default-pie
GCC_CONFIG += --enable-initfini-array
GCC_VER=$GCC_VERSION
" | tee config.mak
  make -j$(nproc)
  make install

  # The HIJACK_* variables are used to override the system binaries for the during
  # the cross-compilation as in to ensure they are actually used instead of the
  # builtin ones from the system, which were compiled for different target.
  HIJACK_AR=$MUSL/bin/ar
  HIJACK_AS=$MUSL/bin/as
  HIJACK_LD=$MUSL/bin/ld
  HIJACK_STRIP=$MUSL/bin/strip
  ln -s $MUSL/bin/$TARGET-ar $HIJACK_AR
  ln -s $MUSL/bin/$TARGET-as $HIJACK_AS
  ln -s $MUSL/bin/$TARGET-ld $HIJACK_LD
  ln -s $MUSL/bin/$TARGET-strip $HIJACK_STRIP

  cd ..
  rm -rf $CROSS_MAKE_FOLDER
}

# generate_wrapper generates a script which filters out unwanted arguments and
# forwards them to the compiler front-end
generate_wrapper() {
  local compiler="$1"
  local default_flags="$2"
  local destination="$3"

  # -nodefaultlibs and -nostartfiles will be ignored (they are usually only
  # passed in when the linker is called by the Rust compiler) because we'll be
  # using musl-gcc for the linker, which does the job of including the relevant
  # startfiles if those options are omitted

  echo "#!/bin/bash

set -eu

args=()

for arg in \"\$@\"; do
  if [ "\${arg:0:4}" = '-Wl,' ]; then
    parsed_arg=\"\${arg:4}\"
  else
    parsed_arg=\"\$arg\"
  fi

  case \"\$parsed_arg\" in
    -Bsymbolic|-symbolic|-Bdynamic|-dynamic|-dy|-shared*|-nodefaultlibs|-nostartfiles|-call_shared|-Werror) continue;;
    *.cc.o|*.cc|*.cpp|*.cpp.o) includes_cxx=true;;
    *.so|*.so.*) echo \"detected dynamic object: \$@\" > /tmp/log.txt; exit 2;;
  esac

  args+=(\"\$arg\")
done

if [ \"\${includes_cxx:-}\" ]; then
  $compiler $BASE_CFLAGS $CXX_INCLUDES $C_INCLUDES \"\${args[@]}\"
else
  $compiler $default_flags \"\${args[@]}\"
fi
" > "$destination"
}

setup_compiler() {
  # We want the headers from libstdc++-dev for compiling the C++ applications
  # e.g. RocksDB
  $APT_INSTALL git libstdc++-$GCC_MAJOR_VERSION-dev

  CC=$MUSL/bin/gcc
  CXX=$MUSL/bin/g++
  ORIGINAL_PATH=$PATH
  PATH=$MUSL/bin:$ORIGINAL_PATH

  # since musl-gcc already adds the relevant includes, nostdinc and nostdinc++ are
  # used to ensure system-level headers are not looked at

  # rpath-link is used to prioritize the libraries' location at link time

  # -fPIC enables Position Independent Code which is a requirement for producing
  # fully-static binaries
  BASE_CFLAGS="-v -static --static -nostdinc -nostdinc++ -static-libgcc -static-libstdc++ -fPIC -Wl,-rpath-link,$TARGET_HOME/lib -Wl,--no-dynamic-linker -Wl,-static -L$TARGET_HOME/lib -Wno-parentheses"

  C_INCLUDES="-I$TARGET_HOME/include -I$MUSL/lib/gcc/$TARGET/$GCC_VERSION/include"
  CXX_INCLUDES="-I$TARGET_HOME/include/c++/$GCC_VERSION -I$TARGET_HOME/include/c++/$GCC_VERSION/$TARGET"

  generate_wrapper $MUSL/bin/$TARGET-gcc "$BASE_CFLAGS $C_INCLUDES $CXX_INCLUDES" $CC
  chmod +x $CC

  # The HIJACK_* variables are used to override the system binaries for the during
  # the cross-compilation as in to ensure they are actually used instead of the
  # builtin ones from the system, which were compiled for different target.
  HIJACK_CC=$MUSL/bin/cc
  HIJACK_CPP=$MUSL/bin/c++
  HIJACK_GNUCC=$MUSL/bin/gnu-cc
  HIJACK_GNUCXX=$MUSL/bin/gnu-cxx
  ln -s $CC $HIJACK_CC
  ln -s $CC $HIJACK_GNUCC
  ln -s $CC $HIJACK_CPP
  ln -s $CC $HIJACK_GNUCXX

  generate_wrapper $MUSL/bin/$TARGET-g++ "$BASE_CFLAGS $CXX_INCLUDES $C_INCLUDES" $CXX
  chmod +x $CXX
}

install_zlib() {
  # ZLib is used in OpenSSL and RocksDB

  local ZLIB_FOLDER=zlib-$ZLIB_VERSION
  local ZLIB_SOURCE=$ZLIB_FOLDER.tar.gz

  cd /tmp
  curl -sqLO https://zlib.net/$ZLIB_SOURCE
  echo "$ZLIB_SHA256SUM $ZLIB_SOURCE" | sha256sum --check
  tar xzf $ZLIB_SOURCE
  rm $ZLIB_SOURCE

  cd $ZLIB_FOLDER
  ./configure \
    --static \
    --prefix=$TARGET_HOME
  make -j$(nproc)
  make install

  cd ..
  rm -rf $ZLIB_FOLDER
}

install_openssl() {
  # OpenSSL is used in Substrate

  local OPENSSL_FOLDER=openssl-$OPENSSL_VERSION
  local OPENSSL_SOURCE=$OPENSSL_FOLDER.tar.gz

  cd /tmp
  curl -sqO https://www.openssl.org/source/$OPENSSL_SOURCE
  echo "$OPENSSL_SHA256SUM $OPENSSL_SOURCE" | sha256sum --check
  tar xzf $OPENSSL_SOURCE
  rm $OPENSSL_SOURCE

  cd $OPENSSL_FOLDER
  ./Configure \
    $OPENSSL_ARCH \
    -static \
    no-shared \
    --prefix=$TARGET_HOME
  make -j$(nproc)
  make install

  cd ..
  rm -rf $OPENSSL_FOLDER
}

install_libunwind() {
  # libunwind is used in jemalloc
  $APT_INSTALL autoconf automake autotools-dev libtool

  local LIBUNWIND_FOLDER=libunwind-$LIBUNWIND_VERSION
  local LIBUNWIND_SOURCE=v$LIBUNWIND_VERSION.zip

  cd /tmp
  curl -sqLO https://github.com/libunwind/libunwind/archive/$LIBUNWIND_SOURCE
  echo "$LIBUNWIND_SHA256SUM $LIBUNWIND_SOURCE" | sha256sum --check
  unzip $LIBUNWIND_SOURCE
  rm $LIBUNWIND_SOURCE

  cd $LIBUNWIND_FOLDER

  # revert https://github.com/libunwind/libunwind/commit/f1684379dfaf8018d5d4c1945e292a56d0fab245
  # use -lgcc because we don't have gcc_s from musl-cross-make
  # gcc_s is the shared library counterpart of gcc_eh according to https://gitlab.kitware.com/cmake/cmake/-/merge_requests/1460
  sed -e 's/-lgcc_s/-lgcc/' -i configure.ac

  autoreconf -i
  ./configure \
    --build=$HOST \
    --host=$TARGET \
    --enable-static \
    --disable-shared \
    --prefix=$TARGET_HOME
  make -j$(nproc)
  make install prefix=$TARGET_HOME

  cd ..
  rm -rf $LIBUNWIND_FOLDER
}

install_jemalloc() {
  # Jemalloc is used in parity-util-mem

  local JEMALLOC_FOLDER=jemalloc-$JEMALLOC_VERSION
  local JEMALLOC_SOURCE=$JEMALLOC_FOLDER.tar.bz2

  cd /tmp
  curl -sqLO https://github.com/jemalloc/jemalloc/releases/download/$JEMALLOC_VERSION/$JEMALLOC_SOURCE
  echo "$JEMALLOC_SHA256SUM $JEMALLOC_SOURCE" | sha256sum --check
  tar xf $JEMALLOC_SOURCE
  rm $JEMALLOC_SOURCE

  cd $JEMALLOC_FOLDER
  ./configure \
    --build=$HOST \
    --host=$TARGET \
    --with-static-libunwind=$TARGET_HOME/lib/libunwind.a \
    --disable-libdl \
    --disable-initial-exec-tls \
    --prefix=$TARGET_HOME
  make -j$(nproc) build_lib_static
  make install_lib_static

  cd ..
  rm -rf $JEMALLOC_FOLDER
}

install_snappy() {
  # snappy is used in RocksDB
  # snappy is ONE OF the compression algorithms alternatives for RocksDB, which supports many different ones
  # however, from Polkadot's dependencies specifically, only snappy is compiled due to:
  # https://github.com/paritytech/parity-common/blob/30a879f4401fa4eac7f4d70be1038d7933e215a1/kvdb-rocksdb/Cargo.toml#L22

  local SNAPPY_FOLDER=snappy-$SNAPPY_VERSION
  local SNAPPY_SOURCE=$SNAPPY_VERSION.tar.gz

  cd /tmp
  curl -sqLO https://github.com/google/snappy/archive/refs/tags/$SNAPPY_SOURCE
  echo "$SNAPPY_SHA256SUM $SNAPPY_SOURCE" | sha256sum --check
  tar xzf $SNAPPY_SOURCE
  rm $SNAPPY_SOURCE

  cd $SNAPPY_FOLDER
  mkdir build
  cd build

  # the compiler front-end wrongly prefers C includes before C++ _for .cc files_
  # (which are C++ code) when calling cc1plus
  # because of that we'll make it so CXX includes come in first for this project
  # and restore the expected behavior after
  #generate_wrapper "$MUSL/bin/$TARGET-gcc $BASE_CFLAGS $CXX_INCLUDES $C_INCLUDES" $CC
  cmake \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_STATIC_LIBS=ON \
    -DSNAPPY_BUILD_TESTS=OFF \
    -DSNAPPY_BUILD_BENCHMARKS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TARGET_HOME \
    ..
  make
  make install

  cd ../..
  rm -rf $SNAPPY_FOLDER
}

install_gflags() {
  # gflags is used in the build process of RocksDB

  local GFLAGS_FOLDER=gflags-$GFLAGS_SHA
  local GFLAGS_SOURCE=$GFLAGS_SHA.zip

  cd /tmp
  curl -sqLO https://github.com/gflags/gflags/archive/$GFLAGS_SOURCE
  echo "$GFLAGS_SHA256SUM $GFLAGS_SOURCE" | sha256sum --check
  unzip -q $GFLAGS_SOURCE
  rm $GFLAGS_SOURCE

  cd $GFLAGS_FOLDER
  mkdir build
  cd build
  cmake \
    -DBUILD_SHARED_LIBS=0 \
    -DBUILD_STATIC_LIBS=1 \
    -DBUILD_TESTING=0 \
    -DGFLAGS_INSTALL_STATIC_LIBS=1 \
    -DBUILD_gflags_LIB=0 \
    -DCMAKE_INSTALL_PREFIX=$TARGET_HOME \
    ..
  make
  make install
  mv $TARGET_HOME/lib/libgflags_nothreads.a $TARGET_HOME/lib/libgflags.a

  cd ../..
  rm -rf gflags
}

install_rocksdb() {
  # RocksDB is used in Substrate

  # We'll opt out of jemalloc and tcmalloc so that, for now, we'll have less
  # components to worry about; those libraries are not strictly necessary for
  # RocksDB to function and could be enabled later
  ROCKSDB_DISABLE_JEMALLOC=1
  ROCKSDB_DISABLE_TCMALLOC=1

  local ROCKSDB_FOLDER=rocksdb-$ROCKSDB_VERSION
  local ROCKSDB_SOURCE=v$ROCKSDB_VERSION.tar.gz

  cd /tmp
  curl -sqLO https://github.com/facebook/rocksdb/archive/refs/tags/$ROCKSDB_SOURCE
  echo "$ROCKSDB_SHA256SUM $ROCKSDB_SOURCE" | sha256sum --check
  tar xzf $ROCKSDB_SOURCE
  rm $ROCKSDB_SOURCE

  cd $ROCKSDB_FOLDER
  PORTABLE=1 DISABLE_JEMALLOC=1 make static_lib
  mv librocksdb.a $TARGET_HOME/lib
  mv include/* $TARGET_HOME/include

  cd ..
  rm -rf $ROCKSDB_FOLDER
}

build_polkadot() {
  # libclang used for compile-time Rust build tools
  $APT_INSTALL libclang-dev

  local RUST_TARGET_GCC_DIR=/usr/local/$TARGET/bin
  local RUST_TARGET_GCC=$RUST_TARGET_GCC_DIR/musl-gcc

  # unhijack the compiler executables because we'll no longer be compiling C
  # directly for the final binary (C might still be compiled for the Rust
  # dependencies build scripts' compile-time tools but we don't care about which
  # toolchain is used for that)
  mkdir -p $RUST_TARGET_GCC_DIR
  mv $CC $RUST_TARGET_GCC
  rm $CXX $HIJACK_AR $HIJACK_AS $HIJACK_LD $HIJACK_STRIP $HIJACK_CC $HIJACK_CPP \
    $HIJACK_GNUCC $HIJACK_GNUCXX
  unset CC CXX
  PATH=$ORIGINAL_PATH

  # https://doc.rust-lang.org/rustc/codegen-options/index.html#link-self-contained
  # link-self-contained=no is used so that the rust compiler does not include the
  # build target's c runtime when it's linking the executable, because we'll be
  # using musl-cross-make's target c runtime instead, which was already used to
  # compile all the libraries above

  # https://doc.rust-lang.org/rustc/codegen-options/index.html#relocation-model
  # relocation-model=pic is used for the same reason why we are using -fPIC in the
  # C compiler's options

  # note: musl-gcc will automatically be picked up for our target on
  # $RUST_TARGET_GCC, thus why we do not need to specify a "runner" in the
  # following configuration
  echo "
[target.$RUST_TARGET]
linker = \"$RUST_TARGET_GCC\"
rustflags = [
  \"-C\", \"target-feature=+crt-static\",
  \"-C\", \"link-self-contained=no\",
  \"-C\", \"prefer-dynamic=no\",
  \"-C\", \"relocation-model=pic\"
]
" > $CARGO_HOME/config

  git clone --branch "$POLKADOT_BRANCH" "$POLKADOT_REPO"
  cd "$(basename "$POLKADOT_REPO")"

  ROCKSDB_STATIC=1 \
  ROCKSDB_LIB_DIR=$TARGET_HOME/lib \
  ROCKSDB_INCLUDE_DIR=$TARGET_HOME/include \
  SNAPPY_STATIC=1 \
  SNAPPY_LIB_DIR=$TARGET_HOME/lib \
  OPENSSL_STATIC=1 \
  OPENSSL_DIR=$TARGET_HOME \
  OPENSSL_INCLUDE_DIR=$TARGET_HOME/include \
  DEP_OPENSSL_INCLUDE=$TARGET_HOME/include \
  OPENSSL_LIB_DIR=$TARGET_HOME/lib \
  Z_STATIC=1 \
  Z_LIB_DIR=$TARGET_HOME/lib \
  JEMALLOC_OVERRIDE=$TARGET_HOME/lib/libjemalloc.a \
  PATH=$RUST_TARGET_GCC_DIR:$PATH \
  RUST_BACKTRACE=full \
  RUSTC_WRAPPER= \
  WASM_BUILD_NO_COLOR=1 \
  BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$TARGET_HOME -target $TARGET" \
    cargo build --target $RUST_TARGET --release --verbose
  mv ./target/$RUST_TARGET/release/polkadot /polkadot

  rm -rf *
}

steps=(
  install_build_tools
  install_musl
  setup_compiler
  install_zlib
  install_openssl
  install_libunwind
  install_jemalloc
  install_snappy
  install_gflags
  install_rocksdb
  install_rust_toolchain
  build_polkadot
)

print_help() {
  echo "
# Note

This script is not self-contained! It's assumed that this script will be
ran in a clean slate container where we'll be free to mess around with the
system's files and potentially leave the system's state broken in case of
failures. You are strongly advised to not use it directly in your system.

# Sub-commands

## build

Run the following steps (in order):
$(printf '%s\n' "${steps[@]}")

## help

Print this help
"
}

main() {
  case "${1:-}" in
    build)
      for step in "${steps[@]}"; do
        "$step"
      done
    ;;
    help)
      print_help
    ;;
    *)
      >&2 echo "ERROR: Command "${1:-}" not recognized"
      print_help
      exit 1
    ;;
  esac
}

main "$@"
