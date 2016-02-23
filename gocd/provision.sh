#!/bin/bash
/*
dpkg - s oracle-java8-installer &>/dev/null || {
    apt-get install -y python-software-properties debconf-utils
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
    apt-get -y install oracle-java8-set-default
}
*/

echo "deb https://download.go.cd /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.go.cd/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install go-server -y

sudo apt-get install git -y