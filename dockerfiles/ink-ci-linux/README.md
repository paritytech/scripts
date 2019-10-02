# Ink-ci-linux

Docker image based on our substrate builder <parity/rust-builder:latest>.

Used to build and test `ink!`.

Dependencies and tools: `g++`, `libssl-dev`, `gcc`, `clang-8`,  
`cmake`, `make`, `git`, `pkg-config`, `curl`, `time`, `rhash`.

Rust versions: stable - default, nightly, nightly-2019-08-30 (as default).

Rust tools: `cargo-audit`, `sccache`, `cargo web`, `wasm-pack`, `clippy` and `rustfmt`. 
`wasm32-unknown-unknown` target.

Link to registry: <https://registry.parity.io/parity/infrastructure/scripts/ink-ci-linux>

## Usage

```
test-ink:
    stage: test
        image: registry.parity.io/parity/infrastructure/scripts/ink-ci-linux
        script:
            - cargo build ...
```
