# bridge-ci-linux

Docker image based on our CI image `<parity-ci-linux:latest>`.

Used to build and test Parity Bridge projects.

## Dependencies and Tools

Parity Ethereum client ([stable](https://releases.parity.io/ethereum/stable/x86_64-unknown-linux-gnu/parity))

Solidity Compiler ([stable](https://solidity.readthedocs.io/en/v0.5.13/installing-solidity.html#binary-packages))

**Inherited from `<parity-ci-linux:latest>`:**

- `clang-8`
- `cmake`
- `curl`
- `g++`
- `gcc`
- `git`
- `libssl-dev`
- `make`
- `pkg-config`
- `rhash`
- `rust-builder`
- `time`

**Rust versions from `<parity-ci-linux:latest>`:**

- stable (default)
- beta
- nightly

**Rust tools & toolchains from `<parity-ci-linux:latest>`:**

- `cargo-audit`
- `sccache`

[Click here](https://registry.parity.io/parity/infrastructure/scripts/bridge-ci-linux) for the registry.

## Usage

```yaml
test-substrate:
    stage: test
        image: registry.parity.io/parity/infrastructure/scripts/bridge-ci-linux
        script:
            - cargo build ...
```
