FROM ubuntu:bionic 

LABEL version="1.7"
LABEL description="SIFT Docker based on Ubuntu 18.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/sift-docker"

ENV container docker 
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN apt-get update && \
apt-get install -y \
software-properties-common \
wget \
gnupg \
curl \
less \
nano \
sudo \
unzip \
zip \
salt-minion \
ssh && \
wget -O - http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2018.3/SALTSTACK-GPG-KEY.pub | apt-key add - && \
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/2018.3 bionic main" | tee /etc/apt/sources.list.d/saltstack.list &&\
apt-get clean && \
apt-get autoremove -y && \
apt-get purge && \
curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.8.5/sift-cli-linux && \
chmod +x /usr/local/bin/sift && \
mkdir /run/sshd && \
\
echo "    X11Forwarding yes" >> /etc/ssh/ssh_config && \
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
usermod -a -G sudo forensics && \
sudo sift install --pre-release --mode=packages-only --user=forensics && \
apt-get autoremove -y && apt-get purge && apt-get clean && \
git clone https://github.com/digitalsleuth/color_ssh_terminal /tmp/colorssh && \
cd /tmp/colorssh && cat color_ssh_terminal >> /home/forensics/.bashrc && cd /tmp && rm -rf colorssh && \
echo source .bashrc >> /home/forensics/.bash_profile && \
chown forensics:forensics /home/forensics/.bashrc && \
cd /mnt && mkdir aff bde e01 ewf ewf_mount iscsi shadow_mount usb vss windows_mount windows_mount1 windows_mount2 windows_mount3 windows_mount4 windows_mount5 && \
cd shadow_mount && for i in {1..30}; do mkdir vss$i; done

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
