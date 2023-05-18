# The unified Parity CI image

This image is used for running CI jobs for Parity repositories. Currently in the testing phrase, it will be used for most of the repositories in the future.

### Specification

The image is based on the latest Ubuntu LTS (`22.04` aka `jammy`) and contains the following:

* Rust stable 1.69.0
* Rust nightly 2022-11-16
* LLVM 15
* Python 3.10
* Ruby 3.0
* Plenty of different utilities required in the CI pipelines
