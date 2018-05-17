FROM golang:alpine

ARG USER_ID
ARG USER_NAME

RUN echo $USER_ID $USER_NAME
RUN adduser -D -u $USER_ID $USER_NAME
RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME &&\
	apk add -U curl git alpine-sdk &&\
	curl https://glide.sh/get | sh

RUN mkdir -p /go/src/github.com/coreywkruger/lw-dev-exercise &&\
    chown -R $USER_NAME:$USER_NAME /go/src/github.com/coreywkruger/lw-dev-exercise

COPY . /go/src/github.com/coreywkruger/lw-dev-exercise
WORKDIR /go/src/github.com/coreywkruger/lw-dev-exercise

RUN glide install