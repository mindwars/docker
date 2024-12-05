FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /ndmd ./cmd/app

# update CA certificates
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

FROM scratch

# Copy CA certificates from the first stage
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy Swagger docs from the first stage
COPY --from=builder /app/docs /docs

ENV APP_ENV=production
ENV GIN_MODE=release

# Copy binary from the first stage
COPY --from=builder /ndmd /ndmd

COPY --from=builder /app/config /config

COPY --from=builder /app/resources /resources

# Run the application
#ENTRYPOINT ["/ndmd", "start:app"]