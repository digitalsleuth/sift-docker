# sift-docker
A SANS SIFT Docker built on Ubuntu 18.04 LTS

Recommend creating a docker network with subnet for future networking between other dockers (if required)

`sudo docker pull digitalsleuth/sift-docker`

`sudo docker network create --subnet=172.20.0.0/16 sift_net`

`sudo docker run -v <local_folder_to_share>:<share_point_in_docker> --net sift_net --hostname sift --ip 172.20.0.3 --privileged --cap-add SYS_ADMIN --cap-add MKNOD --device /dev/fuse digitalsleuth/sift-docker`

Once the docker is running, connect using: ssh -X forensics@172.20.0.3 User and password are both 'forensics'

Added 'runsift.sh' for new users to docker to allow for quick and easy access.
