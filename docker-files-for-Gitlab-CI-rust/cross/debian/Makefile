#IMAGE for build rust debian arch
#Created by Parity Technologies <devops@parity.io>
USER=parity
NAME=rust-debian
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rustup debian image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build rustup debian image"
	@echo "  make push          - push built image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
