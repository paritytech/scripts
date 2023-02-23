# xbuilder-aarch64-unknown-linux-gnu

A Docker image to cross build using the `aarch64-unknown-linux-gnu` target.
This is used to make `arm64` binaries.

## Usage

Here is a sample use to build the `polkadot` binary:
```
TARGET=aarch64-unknown-linux-gnu
docker run --rm -ti \
	-v $PWD:/app parity-xbuilder-${TARGET} \
	-p polkadot \
	--profile production
```

## Build

```
TARGET=aarch64-unknown-linux-gnu
docker build -t parity-xbuilder-${TARGET} -f xbuilder-aarch64-linux-gnu.Dockerfile .
docker images | grep ${TARGET}
```

