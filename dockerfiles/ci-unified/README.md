# The unified Parity CI image

This image is used for running CI jobs for Parity repositories. It could also work for you if you're building something on Substrate.

### Specification

The actual image's revision is based on Debian 11 (aka `bullseye`) and contains the following:

* Rust stable 1.70.0
* Rust nightly 2023-05-23
* LLVM 15
* Python 3.9.2
* Ruby 2.7.4
* Plenty of different utilities required in the CI pipelines

### Tags

Images are tagged with the following pattern:
```
<DISTRO_CODENAME>[ -<RUST_STABLE_VERSION> | -<RUST_STABLE_VERSION-RUST_NIGHTLY_VERSION> ][ -v<DATESTAMP> ]
```
For example:
* `paritytech/ci-unified:bullseye-1.70`
* `paritytech/ci-unified:bullseye-1.70-v20230705`
* `paritytech/ci-unified:bullseye-1.70-2023-05-23`
* `paritytech/ci-unified:bullseye-1.70-2023-05-23-v20230705`

So when we release a new image, the image is tagged with these 4 tags based on the pattern described above.

#### Currently available tag combination flavors (i.e. pairs):

* `bullseye-1.70.0-2023-05-23`
* `bullseye-1.69.0-2023-03-21`

Note that we keep the old pairs for a while, but eventually they will be removed. So please, try to use the actual available pair.

#### `latest` tag

The `latest` tag is an alias for the latest available tag combination flavor. Using `latest` implies that you following the upstream in the rolling release style, so you should be aware of the possible breaking changes (i.e. that replicates previous `ci-linux:production` behavior).
