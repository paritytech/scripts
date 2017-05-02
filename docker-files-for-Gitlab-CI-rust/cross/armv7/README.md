Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv7, [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-armv7:
      stage: build
      image: parity/rust-armv7:gitlab-ci
      script:
        - cargo build ...
```
