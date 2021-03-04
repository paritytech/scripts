# base-ci-linux

Docker image based on [official Debian image](https://hub.docker.com/_/debian) debian:buster.

Used as base for `Substrate`-based CI images.

Our base CI image `<base-ci-linux:latest>`.

Used to build and test Substrate-based projects.

**Dependencies and Tools:**

- `libssl-dev`
- `clang-7`
- `lld`
- `libclang-dev`
- `make`
- `cmake`
- `git`
- `pkg-config`
- `curl`
- `time`
- `rhash`
- `ca-certificates`

[Click here](https://hub.docker.com/repository/docker/paritytech/base-ci-linux) for the registry.

**Rust tools & toolchains:**

- stable (default)
- `sccache`

## Usage

```Dockerfile
FROM paritytech/base-ci-linux:latest
```
