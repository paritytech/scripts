Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv7 for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```
    build-linux-armhf:
      stage: build
      image: parity/parity-ci-armhf:latest
      script:
        - cargo build --target armv7-unknown-linux-gnueabihf $CARGO_OPTIONS
```
