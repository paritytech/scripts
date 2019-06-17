FROM python:3.6-alpine
MAINTAINER devops-team@parity.io

RUN pip install awscli

ADD config /etc/aws.config
ENV AWS_CONFIG_FILE /etc/aws.config

CMD /bin/sh
