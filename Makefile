
MYSQL_ROOT_PASSWORD ?= password
USER_NAME=`whoami`
USER_ID=`id -u`

db:
	docker run -p 5432:5432 -v ${PWD}/data:/var/lib/mysql -v ${PWD}/seed:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} mysql

go_image:
	docker build --build-arg USER_ID=${USER_ID} --build-arg USER_NAME=${USER_NAME} -t employees .

build_api:
	docker run -it --rm --name employees-api employees go build

shell: go_image
	docker run -it --rm --name employees-api -v ${PWD}:/go/src/github.com/coreywkruger/lw-dev-exercise employees /bin/sh

run:
	docker run -it --rm --name employees-api -p 8000:8000 employees ./employees

 