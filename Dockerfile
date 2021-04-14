FROM golang:1.16 as build

ARG GO111MODULE=on
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

WORKDIR /go/src/app
COPY . ./

RUN go build \
    -a \
    -tags netgo \
    -ldflags '-w -extldflags "-static"' \
    -o disk_usage_exporter \
    cmd/root.go

FROM scratch
COPY --from=build /go/src/app/disk_usage_exporter /

EXPOSE 9995
ENTRYPOINT [ "/disk_usage_exporter" ]
