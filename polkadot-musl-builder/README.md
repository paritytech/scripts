# Introduction

[polkadot-musl-builder](./polkadot-musl-builder.sh) is script which builds a
statically-linked Polkadot using musl.

Note: This script is not self-contained! It's assumed that it will be ran in a
clean slate container where we'll be free to mess around with the system's
files and potentially leave the system's state broken in case of failures. You
should not use it directly in your system.

# Usage

## 1. Create the Dockerfile

Create a Dockerfile (the base image should be Debian-based) which will run the
script. For demonstration's sake we'll use `rust:1.56.0-slim-bullseye`, which
uses Rust 1.56, which is is the latest one right now, but it's recommended that
you pick an image which matches Polkadot's Rust version by the time you're
running this script.

```bash
echo "
FROM rust:1.56.0-slim-bullseye

COPY ./polkadot-musl-builder.sh /polkadot-musl-builder.sh
RUN chmod +x /polkadot-musl-builder.sh

# Override the default definitions through ENV directives if you'd like
# Check the polkadot-musl-builder.sh source code for all the available definitions
# POLKADOT_BRANCH can also be a tag instead of a branch name
ENV POLKADOT_BRANCH=master

# Run the script to generate the Polkadot binary
RUN /polkadot-musl-builder.sh build
" > Dockerfile
```

TODO: `/polkadot-musl-builder.sh build` runs all the build steps in a single
`RUN` directive and therefore doesn't leverage caching between it's multiple
internal steps; it should be possible to separate each step in a different
`RUN` directive to overcome this.

## 2. Build the binary inside a container

```sh
docker build . -t polkadot:musl
```

The resulting image will have the statically-linked Polkadot binary placed at
`/polkadot`. This binary can be extracted by creating a temporary container and
using `docker container cp`, as demonstrated below:

```bash
docker container create --name tmp polkadot:musl
docker container cp tmp:/polkadot .
docker container rm tmp
```

## 3. Check the binary

`ldd ./polkadot` should display "statically linked".

You can simply run it with `./polkadot`.
