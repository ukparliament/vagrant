#!/bin/bash
dpkg - s oracle-java8-installer &>/dev/null || {
    apt-get install -y python-software-properties debconf-utils
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
    apt-get -y install oracle-java8-set-default
}

if [ ! -d "/opt/atlassian-bamboo-5.10.0" ]; then
    wget -P /opt https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.10.0.tar.gz
    cd /opt
    tar -xvzf atlassian-bamboo-5.10.0.tar.gz
    rm atlassian-bamboo-5.10.0.tar.gz
    
    if [ ! -d "/home/vagrant/bamboo-home" ]; then
        mkdir /home/vagrant/bamboo-home
    fi
    sudo chmod 0777 atlassian-bamboo-5.10.0/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
    echo "bamboo.home=/home/vagrant/bamboo-home" > atlassian-bamboo-5.10.0/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
    sudo chmod 0644 atlassian-bamboo-5.10.0/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
    
    ./atlassian-bamboo-5.10.0/bin/start-bamboo.sh
    #wget -qO- localhost:8085
fi