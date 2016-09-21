#!/bin/bash
# https://docs.docker.com/engine/installation/linux/ubuntulinux/

echo "127.0.1.1 ubuntu-xenial" >> /etc/hosts

# install prerequisites
apt-get update
apt-get install apt-transport-https ca-certificates -y

# add a new PGP key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get purge lxc-docker
apt-get install linux-image-extra-$(uname -r) -y
apt-get install docker-engine -y

[ $(getent group docker) ] || groupadd docker
usermod -aG docker ubuntu || true
