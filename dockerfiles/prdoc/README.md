# prdoc

Docker image based on `docker.io/parity/base-bin`.

This is a container image for [`prdoc`](https://github.com/paritytech/prdoc). See
[README](https://github.com/paritytech/prdoc#readme) for more details and documentation.

## Build

The provided `build.sh` script clones [the repo](https://github.com/paritytech/prdoc) and builds the image.

## Usage

```bash
# Pick your engine
ENGINE=${ENGINE:-podman}

# Show the help
$ENGINE run --rm -it paritytech/prdoc
# Show the version
$ENGINE run --rm -it paritytech/prdoc --version
```
