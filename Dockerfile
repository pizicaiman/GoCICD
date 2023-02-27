FROM golang:1.20.1 AS builder

LABEL stage=gobuilder

ENV CGO_ENABLED 0
ENV GOPROXY https://goproxy.cn,direct

WORKDIR /build

ADD go.mod .
ADD go.sum .
RUN go mod download
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/main ./main.go

FROM alpine

ENV TZ Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/main /app/main

RUN chmod +x /app/main

CMD ["./main"]