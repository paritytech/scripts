# IMAGE for build rustup
# Created by Parity Technologies <devops-team@parity.io>
USER=parity
NAME=rust-linux
TAG=stretch

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rustup image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build rustup image"
	@echo "  make push          - push build image to the registry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
