Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv7 for [ANDROID](https://www.android.com/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```linux-armv7-android:
      stage: build
      parity/rust-parity-ethereum-android-build:stretch
      script:
        - cargo build ...
```
