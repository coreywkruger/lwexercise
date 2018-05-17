FROM golang:alpine

RUN apk add -U curl git alpine-sdk &&\
	curl https://glide.sh/get | sh

RUN mkdir -p /go/src/github.com/coreywkruger/employees
COPY . /go/src/github.com/coreywkruger/employees
WORKDIR /go/src/github.com/coreywkruger/employees
