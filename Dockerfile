FROM golang:1.20.1 AS builder
MAINTAINER CJF

WORKDIR /app

COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN --mount=type=cache,target=/go --mount=type=cache,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o main

FROM alpine:3.14.0

COPY --from=builder /app/main /app

ENTRYPOINT ["/app/main"]