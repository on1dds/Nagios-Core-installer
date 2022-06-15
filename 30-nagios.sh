#!/bin/bash

echo ============================================================================
echo  nagios
echo ============================================================================

echo  create accounts and groups
echo  --------------------------
sudo useradd nagios

password=""
p2="x"
while [ "$password" != "$p2" ]
	do
	read -p "enter password for user nagios:" -s password
	echo
	read -p "reenter password:" -s p2
	if [ $password != $p2 ]
	then
		echo "passwords don't match"
	fi
	done
echo


echo 'nagios:$password' | chpasswd
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagcmd www-data
sudo usermod -a -G nagios $USER

echo  download, compile en install nagios
echo ------------------------------------

cd /opt/
wget "https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz"
sleep 2
tar xzf nagios-4.4.6.tar.gz
cd nagios-4.4.6
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf

# nagios authentication
password=""
p2="x"
while [ "$password" != "$p2" ]
	do
	read -p "enter password for nagiosadmin:" -s password
	echo
	read -p "reenter password:" -s p2
	if [ $password != $p2 ]
	then
		echo "passwords don't match"
	fi
	done
echo

sudo htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin $password
sudo systemctl restart apache2

echo  download en install standard nagios plugins
echo  -------------------------------------------
cd /opt
wget "http://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz"
sleep 2
tar xzf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

sudo echo alias c="cd /usr/local/nagios/" >>~/.bashrc
sudo systemctl enable apache2
sudo systemctl restart apache2
sudo systemctl enable nagios 
sudo systemctl start nagios

echo Nagios is ready to use at:
echo https://$(dnsdomainname -f)/nagios
