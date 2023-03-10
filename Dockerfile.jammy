FROM ubuntu:22.04

LABEL version="5.0"
LABEL description="SANS Investigative Forensic Toolkit based on Ubuntu 22.04 LTS"
LABEL maintainer="Corey Forman (github.com/digitalsleuth)"
LABEL sift_release="v2023.02.06"
ARG CAST_VERSION=0.14.0
ARG SIFT_USER=sansforensics
ARG SIFT_DESCRIPTION="SANSForensics User"
ARG SIFT_PASSWORD="forensics"

USER root

WORKDIR /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget gnupg git openssh-server && \
    groupadd -r -g 1000 ${SIFT_USER} && \
    useradd -r -g ${SIFT_USER} -d /home/${SIFT_USER} -s /bin/bash -c "${SIFT_DESCRIPTION}" -u 1000 ${SIFT_USER} && \
    mkdir /home/${SIFT_USER} && \
    touch /home/${SIFT_USER}/.Xauthority && \
    chown -R ${SIFT_USER}:${SIFT_USER} /home/${SIFT_USER} && \
    usermod -a -G sudo ${SIFT_USER} && \
    echo "${SIFT_USER}:${SIFT_PASSWORD}" | chpasswd && \
    wget https://github.com/ekristen/cast/releases/download/v${CAST_VERSION}/cast_v${CAST_VERSION}_linux_amd64.deb && \
    dpkg -i /tmp/cast_v${CAST_VERSION}_linux_amd64.deb && \
    cast install --mode server --user ${SIFT_USER} sift && \
    rm /tmp/cast_v${CAST_VERSION}_linux_amd64.deb

RUN echo "UseDNS no" >> /etc/ssh/sshd_config && \
    echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PrintLastLog yes" >> /etc/ssh/sshd_config && \
    echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config && \
    echo "X11DisplayOffset 10" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config && \
    git clone https://github.com/digitalsleuth/color_ssh_terminal /tmp/colorssh && \
    cd /tmp/colorssh && cat color_ssh_terminal >> /home/${SIFT_USER}/.bashrc && cd /tmp && rm -rf colorssh && \
    echo source .bashrc >> /home/${SIFT_USER}/.bash_profile && \
    chown -R ${SIFT_USER}:${SIFT_USER} /home/${SIFT_USER} && \
    apt-get autoremove -y && apt-get purge && apt-get clean && \
    rm -rf /srv && \
    rm -rf /var/cache/salt/* && \
    rm -rf /root/.cache/* && \
    unset DEBIAN_FRONTEND

ENV TERM linux
WORKDIR /home/${SIFT_USER}

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
