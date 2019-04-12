Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv7, [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```
    build-linux-armhf:
      stage: build
      image: parity/rust-parity-ethereum-build:armhf
      script:
        - cargo build --target armv7-unknown-linux-gnueabihf $CARGO_OPTIONS
```
