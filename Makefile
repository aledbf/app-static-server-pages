all: build test

build:
	go build -a -v -ldflags '-s' main.go

test:
	go test -v ./...

test-cover:
	go test -cover ./...
