#!/bin/bash
# Install JDK 9
dpkg - s oracle-java8-installer &>/dev/null || {
    apt-get install -y python-software-properties debconf-utils
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
    apt-get -y install oracle-java8-set-default
}

# Install Bamboo and run as a service
# Inspired by https://confluence.atlassian.com/bamboo/running-bamboo-as-a-linux-service-416056046.html
if [ ! -f "/etc/init.d/bamboo" ]; then
    # Create a user "bamboo" to run Bamboo as a service
    useradd --create-home -c "Bamboo role account" bamboo
    # Create Bamboo HOME directory
    mkdir -p /var/atlassian/application-data/bamboo
    # Create an installation folder
    mkdir -p /opt/atlassian/bamboo
    
    # Download and extract Bamboo from Atlassian website
    cd /opt/atlassian/bamboo
    wget -P . https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.10.1.1.tar.gz
    tar -xvzf atlassian-bamboo-5.10.1.1.tar.gz
    rm atlassian-bamboo-5.10.1.1.tar.gz
    # Create a symlink
    ln -s atlassian-bamboo-5.10.1.1/ current
    # Set bamboo.home in bamboo-init.properties
    echo "bamboo.home=/var/atlassian/application-data/bamboo" > atlassian-bamboo-5.10.1.1/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
    # Change the owner of the whole directory to bamboo
    chown -R bamboo: /opt/atlassian/bamboo
    
    # Create /etc/init.d/bamboo
    echo '#!/bin/sh
set -e
### BEGIN INIT INFO
# Provides: bamboo
# Required-Start: $local_fs $remote_fs $network $time
# Required-Stop: $local_fs $remote_fs $network $time
# Should-Start: $syslog
# Should-Stop: $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Atlassian Bamboo Server
### END INIT INFO
# INIT Script
######################################

# Define some variables
# Name of app ( bamboo, Confluence, etc )
APP=bamboo
# Name of the user to run as
USER=bamboo
# Location of application''s bin directory
BASE=/opt/atlassian/bamboo/current

case "$1" in
  # Start command
  start)
    echo "Starting $APP"
    /bin/su - $USER -c "export BAMBOO_HOME=${BAMBOO_HOME}; $BASE/bin/startup.sh &> /dev/null"
    ;;
  # Stop command
  stop)
    echo "Stopping $APP"
    /bin/su - $USER -c "$BASE/bin/shutdown.sh &> /dev/null"
    echo "$APP stopped successfully"
    ;;
   # Restart command
   restart)
        $0 stop
        sleep 5
        $0 start
        ;;
  *)
    echo "Usage: /etc/init.d/$APP {start|restart|stop}"
    exit 1
    ;;
esac

exit 0' > /etc/init.d/bamboo
    chmod \+x /etc/init.d/bamboo
    update-rc.d bamboo defaults
    
    service bamboo start
fi