#!/bin/bash

echo ============================================================================
echo  basic setup
echo ============================================================================

#echo "Set hostname"
#hostnamectl set-hostname monitoring.home.lan

echo "Disable IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

echo "Register APT - Free Repositories"
cat >/etc/apt/sources.list <<EOL
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free
EOL

apt -y update && apt -y upgrade

# install hardware specific tools
apt -y install lm-sensors fancontrol read-edid i2c-tools

# install basic tools
apt -y install curl sudo vim wget unzip 

# ----------------------------
# VIM
# ----------------------------
cat >/etc/vim/vimrc.local << EOL
syntax enable      " enable syntax highlighting
set tabstop=4      " number of visual spaces per TAB
set softtabstop=4  " number of spaces in tab when editing
set expandtab      " tabs are spaces
set number         " show line numbers
set showcmd        " show command in bottom bar
set mouse-=a       " no mouse 
set ignorecase
set smartcase
syntax on
set cursorline     " highlight current line
filetype on
filetype indent on
set wildmenu
set lazyredraw     " redraw only when we need to
set showmatch      " highlight matching [{( )}]
EOL

apt -y install network-manager
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

apt -y install firewalld
systemctl enable firewalld
systemctl start firewalld

apt -y autoremove

