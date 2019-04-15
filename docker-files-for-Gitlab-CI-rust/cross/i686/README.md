Docker images with preinstalled [RUST](https://www.rust-lang.org/) i686 for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```
    build-linux-i386:
      stage: build
      image: parity/rust-parity-ethereum-build:i386
      script:
        - cargo build --target i686-unknown-linux-gnu $CARGO_OPTIONS
```
