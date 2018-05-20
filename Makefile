
PROG = app
GOFLAGS ?= $(GOFLAGS:)

all: clean install build
	./$(PROG)

install:
	glide i

build:
	go build -o $(PROG) $(GOFLAGS) ./...

clean:
	go clean $(GOFLAGS) -i ./...

test:
	go test

run:
	./$(PROG)