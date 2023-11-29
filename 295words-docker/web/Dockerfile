FROM golang:1.18-alpine AS builder

WORKDIR /app

COPY dispatcher.go /app
COPY . /app

RUN go build -o main dispatcher.go

EXPOSE 80

CMD ["./main"]