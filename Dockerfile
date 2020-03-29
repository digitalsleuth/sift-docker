FROM ubuntu:bionic 

LABEL version="1.4"
LABEL description="SIFT Docker based on Ubuntu 18.04 LTS"
LABEL maintainer="https://github.com/fetchered/sift18-docker"

ENV container docker 
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN apt-get update && \
apt-get install -y \
software-properties-common \
wget \
gnupg \
ssh && \
wget -O - http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2018.3/SALTSTACK-GPG-KEY.pub | apt-key add - && \
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2018.3 bionic main" | tee /etc/apt/sources.list.d/saltstack.list &&\
add-apt-repository ppa:malteworld/ppa && \
apt-get update &&\
apt-get install -y \
salt-minion \
ant \
build-essential \
curl \
default-jdk-headless \
fuse \
gcc \
init \
libbcprov-java \
libcommons-lang3-java \
less \
make \
nano \
p7zip \
pdftk \
sudo \
unzip \
zip && \
apt-get clean && \
apt-get autoremove -y && \
curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.8.5/sift-cli-linux && \
chmod +x /usr/local/bin/sift && \
mkdir /run/sshd

RUN echo "    X11Forwarding yes" >> /etc/ssh/ssh_config && \
echo "    X11DisplayOffset 10" >> /etc/ssh/ssh_config && \
echo "    PrintMotd no" >> /etc/ssh/ssh_config && \
echo "    PrintLastLog yes" >> /etc/ssh/ssh_config && \
echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config && \
echo "    ForwardX11 yes" >> /etc/ssh/ssh_config && \
echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

RUN groupadd -r forensics && \
useradd -r -g forensics -d /home/forensics -s /bin/bash -c "SIFT User" forensics && \
mkdir /home/forensics && \
chown -R forensics:forensics /home/forensics && \
echo 'forensics:forensics' | chpasswd && \
usermod -a -G sudo forensics
RUN sudo sift install --pre-release --mode=packages-only --user=forensics
RUN apt-get autoremove -y && apt-get purge && apt-get clean && \
git clone https://gist.github.com/fetchered/c6c711f30c2bd5452aa37a5b12a57474 /tmp/colorssh && \
cd /tmp/colorssh && cat color_ssh_terminal >> /home/forensics/.bashrc && cd /tmp && rm -rf colorssh && \
echo source .bashrc >> /home/forensics/.bash_profile && \
chown forensics:forensics /home/forensics/.bashrc

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
