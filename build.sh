#!/bin/bash

docker run -v $PWD/data:/var/lib/mysql -v $PWD/seed:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=password mysql # mysql < employees.sql
