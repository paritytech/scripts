# substrate-ci-linux

Docker image based on [official Rust image](https://hub.docker.com/_/rust).

Used as base for `Substrate`-based CI images.

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test Substrate-based projects.

**Dependencies and Tools:**

- `clang-9`
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

**Rust versions:**

-   stable (default)
-   nightly

[Click here](https://registry.parity.io/parity/infrastructure/scripts/base-ci-linux) for the registry.

## Usage

```Dockerfile
FROM registry.parity.io/parity/infrastructure/scripts/base-ci-linux:latest
```
