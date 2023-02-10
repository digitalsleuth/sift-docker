# sift-docker  ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/digitalsleuth/sift-docker)
A SANS SIFT Docker built on Ubuntu 20.04 and 22.04 LTS   

Using the docker-compose.yaml file included will create a docker network with subnet for future networking between other dockers (if required)
It will also add a custom IP to that network (for ease of connecting), enable the privileged, cap_add SYS_ADMIN and MKNOD features, as well as adding the
device /dev/fuse to enable full mounting capability and FUSE level access.

Customize the .yaml file for either the Focal or Jammy image, IP address and subsequent volumes.

An additional feature of this build is the use of X11 Forwarding. Once the docker is up and running (using `sudo docker-compose up -d`), use the following:

`ssh -X sansforensics@<ip_address> -p 33`

This will enable X11 forwarding to allow for GUI access to any GUI-enabled applications (such as `bless`).
