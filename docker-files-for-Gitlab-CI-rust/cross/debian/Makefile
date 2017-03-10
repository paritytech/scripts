#IMAGE for build rust debian arch
#Created by Denis S. Soldatov aka General-Beck general-beck@ethcore.io
USER=ethcore
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
