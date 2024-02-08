FROM golang:1.22 as builder

WORKDIR /app
COPY . .
RUN make build

FROM busybox:glibc AS app

WORKDIR /app
COPY --from=builder /app/dist/hey-yo-http /bin/

EXPOSE 8080
ENTRYPOINT ["/bin/hey-yo-http"]
