Docker images with preinstalled [RUST](https://www.rust-lang.org/) stable x86_64 CentOS 7.3.1611, [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-centos:
      stage: build
      image: parity/rust-centos:gitlab-ci
      script:
        - cargo build ...
```
