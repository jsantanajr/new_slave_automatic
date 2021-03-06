#!/bin/bash

host_master=$1

# CREATE SSH KEY FOR CONNECT SLAVE TO MASTER

 ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
 ssh-copy-id root@$1
 ssh root@$1 "ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
 KEY_M=`ssh root@$1 'cat ~/.ssh/id_rsa.pub'`
 echo $KEY_M > ~/.ssh/authorized_keys
	
if [ $? -eq 0 ]; then

  echo Create ssh key with successfully!

else

  echo Failed for create key!

fi


#INSTALL XTRABACKUP 

if [[ -e /etc/redhat-release ]]; then

  echo Install packages

  ssh root@$1 'yum -d 0 -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm epel-release; yum -d 0 -y install percona-toolkit percona-xtrabackup pigz pwgen'

  echo Installed packages with successful

elif [[ -e /etc/debian_version ]]; then

  echo Install packages

  ssh root@$1 'apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A ;  echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | tee /etc/apt/sources.list.d/percona.list ; apt-get -y install percona-xtrabackup; apt-get -y install pigz'

  echo Installed packages with successful

else

echo Failed to install xtrabackup and dependencies

fi
