FROM alpine:latest

ARG VCS_REF
ARG BUILD_DATE
ARG HELM_VERSION
ARG KUBE_VERSION

LABEL org.label-schema.maintainer="devops-team@parity.io" \
	org.label-schema.vendor="Parity Technologies" \
	org.label-schema.description="Image with Kube and Helm." \
	org.label-schema.vcs-ref="${VCS_REF}" \
	org.label-schema.name="kubetools" \
	org.label-schema.url="https://hub.docker.com/r/paritytech/kubetools/" \
	org.label-schema.vcs-url="https://github.com/paritytech/scripts/kubetools" \
	org.label-schema.build-date="${BUILD_DATE}"

ADD "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" \
	/usr/local/bin/kubectl
ADD "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
	/usr/local/bin/helm
RUN wget -q "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O - | tar -xzO linux-amd64/helm \
	> /usr/local/bin/helm
RUN apk add --no-cache \
	ca-certificates git jq make curl gettext; \
	chmod +x /usr/local/bin/kubectl; \
	chmod +x /usr/local/bin/helm

WORKDIR /config

CMD /bin/sh
