# syntax=docker/dockerfile:1.3
FROM golang:1.18-alpine3.16 AS build
RUN apk add --update --no-cache gcc libc-dev make git
WORKDIR /workspace
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod go mod download
COPY Makefile ./
RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  make

FROM alpine:3.16
RUN apk add --update --no-cache ca-certificates
COPY --from=build --chown=nonroot:nonroot /workspace/build/olricd /usr/bin/olricd
COPY --from=build --chown=nonroot:nonroot /workspace/build/olric-cloud-plugin.so /usr/lib/olric-cloud-plugin.so
CMD ["/usr/bin/olricd"]
