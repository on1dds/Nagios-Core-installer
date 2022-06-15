# Nagios-Core-installer
This is a collection of scripts for completely installing Nagios Core 4.4.6 and plugins from source on Debian 11 (Bullseye). These scripts also automate the full installation and configuration of apache, including CGI, PHP, certificate generation, HTTPS redirection, ...

## requirements
- (virtual) machine with minimum 1 CPU, 2 GB RAM and 20 GB diskspace
- Debian 11 minimal install including SSH server and standard system utilities (No desktop environment required)
- make sure your user is member of the sudoers group (`usermod -aG sudo username`)
- set the hostname to its FQDN during installation (e.g. nagios.home.lan)

## 10-basics.sh
run this as root (`su -`)
- disable IPv6
- register free repositories
- update and upgrade the system
- install some necessary tools like curl, sudo, vim, wget, unzip
- install hardware specific tools
- configure VIM as I like it. perhaps you prefer another editor
- install NetworkManager and firewalld

after this, it is advised to set fixed IP address and disable wifi (e.g. `nmtui`) 

## 20-apache.sh
run this as sudo user
- install apache2
- open http and https ports in firewall
- install and test CGI with a perl script
- install PHP and modules and enable them in apache
- show url for testing PHP remotely
- setup HTTPS
- generate root certificate
- generate nagios server certificate
- register certificates in apache
- enable redirect from http to https
- enable SSL in apache2 and set as default''
- run a configuration test and show 

## 25-build.sh
run this as sudo user
- install build essentials
- install perl and addons
- install python and addons

## 30-nagios.sh
run this as sudo user
- download, compile and install nagios 4.4.6
- create a nagiosadmin user
- download, compile and install nagios plugins 2.3.3

nagios is now up and running
