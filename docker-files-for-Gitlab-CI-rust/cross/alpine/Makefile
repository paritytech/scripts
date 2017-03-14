#IMAGE for build rust-alpine
#Created by Denis S. Soldatov aka General-Beck general-beck@ethcore.io
USER=ethcore
NAME=rust-alpine
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rust-alpine image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build alpine-centos image"
	@echo "  make push          - push built image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
