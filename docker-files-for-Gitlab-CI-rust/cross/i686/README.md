Docker images with preinstalled [RUST](https://www.rust-lang.org/) stable i686 Ubuntu Trusty, [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-stable:
      stage: build
      image: parity/rust-i686:gitlab-ci
      script:
        - cargo build ...
```
