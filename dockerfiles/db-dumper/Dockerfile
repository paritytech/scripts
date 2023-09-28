FROM python:3.11-slim-bookworm

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/db-dumper" \
	io.parity.image.description="A script that makes dumps of GCP Cloud SQL Postgres databases\
to a GCP Cloud storage bucket." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/db-dumper/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/db-dumper/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN mkdir /opt/app
WORKDIR /opt/app

COPY db-dumper/app.py .
COPY db-dumper/requirements.txt .

RUN pip3 --no-cache-dir install -r requirements.txt

USER nobody:nogroup

CMD ["python", "./app.py"]