# CLI is written in Go, we'll build it
FROM golang:1.19-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod to download dependencies
# Even if go.sum is missing, copying go.mod is good practice
COPY go.mod ./
# Download dependencies if any (no go.sum means maybe no external deps yet or managed by go mod tidy automatically)
RUN go mod download

# Copy the source code
COPY . .

# Build the application
# We build the binary from the cmd/minml.go file
RUN CGO_ENABLED=0 GOOS=linux go build -o /usr/local/bin/minml ./go/markup/minml/cmd/minml.go

# Final stage
FROM alpine:latest

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /usr/local/bin/minml /usr/local/bin/minml

# define the entrypoint so it can be used as a CLI
ENTRYPOINT ["minml"]
