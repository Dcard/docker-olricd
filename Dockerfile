# syntax=docker/dockerfile:1.3
FROM golang:1.18-bullseye AS build
WORKDIR /workspace
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod go mod download
COPY Makefile ./
RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  make

FROM debian:bullseye
COPY --from=build --chown=nonroot:nonroot /workspace/build/olricd /usr/bin/olricd
COPY --from=build --chown=nonroot:nonroot /workspace/build/olric-cloud-plugin.so /usr/lib/olric-cloud-plugin.so
CMD ["/usr/bin/olricd"]
