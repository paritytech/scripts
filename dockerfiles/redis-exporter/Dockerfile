#docker image from https://github.com/oliver006/redis_exporter
FROM golang:1.13-alpine as builder

RUN apk --no-cache add ca-certificates git

RUN go get github.com/oliver006/redis_exporter
RUN cd ${GOPATH}/src/github.com/oliver006/redis_exporter && go build


FROM alpine as alpine
COPY --from=builder /go/src/github.com/oliver006/redis_exporter/redis_exporter /redis_exporter
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Run as non-root user for secure environments
USER 59000:59000

EXPOSE     9121
ENTRYPOINT [ "/redis_exporter" ]
