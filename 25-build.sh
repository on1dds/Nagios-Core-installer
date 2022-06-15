#!/bin/bash
#

sudo apt -y install build-essential

# Install Perl and addons
yes | sudo pecl channel-update pecl.php.net
yes | sudo cpan install XML::LibXML
yes | sudo cpan install XML::Simple
yes | sudo cpan install Term::ReadLine::Perl
yes | sudo cpan install Net::SNMP
yes | sudo cpan install IO::Socket::SSL
yes | sudo cpan install Net::Ping
yes | sudo cpan install Nagios::Monitoring::Plugin


# Install Python and addons
sudo apt -y install python python3 python3-pip python3-xlrd
sudo pip install pyvmomi
sudo pip install tools
sudo pip install pylint

sudo apt autoremove
