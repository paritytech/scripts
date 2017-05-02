#IMAGE for build rust i686 arch
#Created by Parity Technologies <devops@parity.io>
USER=parity
NAME=rust-i686
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rustup i686 image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build rustup arm image"
	@echo "  make push          - push built image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
