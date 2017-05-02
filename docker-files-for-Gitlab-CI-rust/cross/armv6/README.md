Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv6, [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-armv6:
      stage: build
      image: parity/rust-armv6:gitlab-ci
      script:
        - cargo build ...
```
