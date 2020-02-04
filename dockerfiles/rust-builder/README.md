# Rust-builder
Docker image based on [official Rust image](https://hub.docker.com/_/rust).

Used to build and test `Substrate`-based projects.

Dependencies and tools: `g++`, `libssl-dev`, `gcc`, `clang-9`, `libclang-9-dev`, `lld-9`,
`cmake`, `make`, `git`, `pkg-config`, `curl`, `time`, `rhash`.

Rust versions: stable - default, nightly.

Rust tools: `cargo-audit`, `sccache`, `cargo web` and `wasm-pack`,  
`wasm32-unknown-unknown` target.

Link to registry: https://registry.parity.io/v2/...

## Usage:
```
build-substrate:
    stage: build
        image: parity/rust-builder:latest
        script:
            - rustup default stable
            - cargo build ...
```
