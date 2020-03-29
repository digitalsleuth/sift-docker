# sift-docker
A SANS SIFT Docker built on Ubuntu 18.04 LTS

Recommend creating a docker network with subnet for future networking between other dockers (if required)

sudo docker network create --subnet=172.20.0.0/16 siftnet\
sudo docker run -v <local_folder_to_share>:<share_point_in_docker> --net siftnet -h siftdock --ip 172.20.0.1 <image_name>\

Once the docker is running, connect using: ssh -X forensics@172.20.0.1 User and password are both 'forensics'
