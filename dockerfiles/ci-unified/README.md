# The unified Parity CI image

This image is used for running CI jobs for Parity repositories. Currently in the testing phrase, it will be used for most of the repositories in the future.

### Specification

The image is based on the latest Debian 11 (aka `bullseye`) and contains the following:

* Rust stable 1.69.0
* Rust nightly 2023-05-23
* LLVM 15
* Python 3.9.2
* Ruby 2.7.4
* Plenty of different utilities required in the CI pipelines
