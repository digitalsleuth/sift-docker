#!/bin/bash

#Run your docker, detached, connect it to sift_net with a hostname of sift and an IP as listed below
# Add -v <local_folder_to_share>:<folder_to_create> to the docker command to share files between OS and docker
# --privileged, --cap-add SYS_ADMIN and --cap-add MKNOD are required to provide the required permissions to mount fuse devices
sudo docker network rm sift_net > /dev/null
sudo docker network create --subnet=172.21.0.0/16 sift_net > /dev/null 
sudo docker run -d -v <host_folder_to_share>:<docker_folder_to_map>:ro --net sift_net --hostname sift --ip 172.21.0.3 --name sift --privileged --cap-add SYS_ADMIN --cap-add MKNOD --device /dev/fuse digitalsleuth/sift-docker > /dev/null
sudo docker ps -q | sudo xargs -n 1 docker inspect --format "{{.Config.Image}} {{.Name}} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}"
