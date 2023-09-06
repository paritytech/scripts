# `base-bin`

A frequently built and updated image to be used as base for our binary distribution.
The image is not named after a specific distribution such as `ubuntu` to leave us the option
to change the base image over time.

This base image is Parity opinionated and contains our GPG keys.

Unlike the `base-ci-linux` image which contain development toolchains, this image is meant to be used as base image for final delivery of binaries.

## Build

See `./build.sh`
