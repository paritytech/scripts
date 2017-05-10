#IMAGE for build rust TOOLCHAIN
#Created by Parity Technologies <devops@parity.io>
USER=parity
NAME=rust
CHANNEL=${TOOLCHAIN}

help:
	@echo "Build rust image."
	@echo
	@echo "Usage:"
	@echo "    make [help]                      - show this message"
	@echo "    make images                      - build beta, stable, and nightly rust"
	@echo "    make push                        - push built images to the registry"
	@echo "    make (beta | stable | nightly)   - build image for specific rust channel"
	@echo "    make TOOLCHAIN=<toolchain> build - build image for specific rust toolchain"

images: beta stable nightly

stable:
	make TOOLCHAIN=stable build

beta:
	make TOOLCHAIN=beta build

nightly:
	make TOOLCHAIN=nightly build

build:
	docker build --tag "${USER}/${NAME}:${CHANNEL}" \
	--build-arg channel=${CHANNEL} .
push:
	docker push "${USER}/${NAME}"

.PHONY: images help stable beta nightly build push
