#!/bin/sh

#rm all stopped
docker rm $(docker ps -a -q)

#remove all unused/untagged images 
docker rmi `docker images -q --filter "dangling=true"` 

#remove all unused/untagged volumes
docker volume rm `docker volume ls -q --filter "dangling=true"`




