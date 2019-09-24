# query-exporter Dockerfile
FROM python:3-alpine

WORKDIR /usr/src/app

RUN \
  apk add --no-cache postgresql-libs && \
	apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
	python3 -m pip install --no-cache-dir SQLAlchemy[postgresql] query-exporter && \
	apk --purge del .build-deps

CMD ["python3", "/usr/local/bin/query-exporter"]
