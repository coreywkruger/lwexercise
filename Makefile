
PROG = employees
GOFLAGS ?= $(GOFLAGS:)

all: clean install build
	./employees

install:
	glide i

build:
	go build -o $(PROG) $(GOFLAGS) ./...

clean:
	go clean $(GOFLAGS) -i ./...
