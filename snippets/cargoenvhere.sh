#!/bin/bash

# "Cargo as a virtual environment in the current dir"
dirname="$(basename $(pwd))"
user=$(whoami)
echo "Cargo as a virtual environment in" "$dirname" "dir"
mkdir -p /home/"$user"/cache/"$dirname"
podman run --rm -it -w /shellhere/"$dirname" \
                    -v "$(pwd)":/shellhere/"$dirname" \
                    -v /home/"$user"/cache/"$dirname"/:/cache/ \
                    -e CARGO_HOME=/cache/cargo/ \
                    -e SCCACHE_DIR=/cache/sccache/ \
                    -e CARGO_TARGET_DIR=/cache/target/ "$@"

# example use
# cargoenvhere paritytech/ci-linux:production /bin/bash -c 'RUSTFLAGS="-Cdebug-assertions=y -Dwarnings" RUST_BACKTRACE=1 time cargo test --workspace --locked --release --verbose --features runtime-benchmarks --manifest-path bin/node/cli/Cargo.toml'
