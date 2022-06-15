# Nagios-Core-installer
This is a collection of scripts for installing Nagios Core 4.4.6 on Debian 11 (Bullseye)

I prefer installing my Nagios server on an old laptop to ensure it keeps running on a power outage.

## requirements
- (virtual) machine with minimum 1 CPU, 2 GB RAM and 20 GB diskspace
- Debian 11 minimal install with SSH server an standard system utilities selected (No desktop environment required)
- make sure your user is member of the sudoers group (`usermod -aG sudo username`)
- set the hostname to its FQDN during installation (e.g. nagios.home.lan)

## 10-basics.sh
run this as root (`su -`)
- set hostname
- disable IPv6
- register free repositories
- update and upgrade the system
- install some necessary tools like curl, sudo, vim, wget, unzip
- configure VIM as I like it. perhaps you prefer another editor
- install NetworkManager and firewalld

after this, it is advised to set fixed IP address and disable wifi (e.g. `nmtui`) 

## 20-nagios-prep.sh
before running this script:
- replace all %PASSWORD% with a password for the 'nagios' user account

run this script as a user with elevated rights
