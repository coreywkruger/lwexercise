
# MYSQL_PASSWORD ?= password
MYSQL_ROOT_PASSWORD ?= password
# MYSQL_USER ?= `whoami`
# UID=`id -u`

init:
	docker run -v ${PWD}/data:/var/lib/mysql -v ${PWD}/seed:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} mysql
