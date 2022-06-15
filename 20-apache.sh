#!/bin/bash
#
# script to install 
# - nagios core 
# 

# install and run apache
sudo apt -y install apache2

sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload

# Install CGI for apache
sudo a2enmod rewrite cgi cgid
sudo systemctl reload apache2
sudo systemctl restart apache2


cat > /tmp/test_script <<EOF
#!/usr/bin/perl
print "Content-type: text/html\n\n";
print "OK: CGI is working!!!\n";
EOF
sudo mv /tmp/test_script /usr/lib/cgi-bin
sudo chmod 705 /usr/lib/cgi-bin/test_script
curl localhost/cgi-bin/test_script

echo "press <ENTER> to continue"
read

# Install PHP
sudo apt -y install php php-cgi libapache2-mod-php php-common php-pear php-mbstring  php-dev
sudo apt -y install php-cli php-zip php-curl php-xml php-fpm php-json php-pdo php-gd php-bcmath
sudo apt -y install php-sybase php-db

sudo a2enconf php*
sudo systemctl reload apache2
sudo systemctl restart apache2

sudo bash -c "echo '<?php phpinfo(); ?>' > /var/www/html/info.php"
ip=$(ip addr | grep inet | grep -v inet6 | grep -v '127.0.0.' | tail -1 | awk '{print $2}' | cut -d '/' -f1)
echo "test if PHP works by browsing to http://$ip/info.php"
echo "press <ENTER> to continue"
read


echo ----------------
echo Setup HTTPS
echo ----------------

sudo apt -y install libssl-dev

# Generate certificates
cd /etc/ssl/certs/
openssl genrsa -out rootca.key 2048
openssl req -x509 -new -nodes -key rootca.key -sha256 -days 1024 -out rootca.pem -subj "/C=/ST=/L=/O=/OU=/CN=$(dnsdomainname -d)"
openssl genrsa -out nagios.key 2048
openssl req -new -key nagios.key -out nagios.csr -subj "/C=/ST=/L=/O=/OU=/CN=$(dnsdomainname -f)"
openssl x509 -req -in nagios.csr -CA rootca.pem -CAkey rootca.key -CAcreateserial -out nagios.pem -days 1024 -sha256


# Register certificates in apache
sed -i '/snakeoil.pem/c\'"SSLCertificateFile /etc/ssl/certs/nagios.pem" /etc/apache2/sites-available/default-ssl.conf
sed -i '/snakeoil.key/c\'"SSLCertificateKeyFile /etc/ssl/certs/nagios.key" /etc/apache2/sites-available/default-ssl.conf
sed -i '/#SSLCertificateChainFile/c\'"SSLCertificateChainFile /etc/ssl/certs/rootca.pem" /etc/apache2/sites-available/default-ssl.conf

# HTTP redirect to HTTPS
sed -i '/trace8/c\'"Redirect permanent \/ https:\/\/$(dnsdomainname -f)\/" /etc/apache2/sites-available/000-default.conf

a2enmod rewrite ssl headers
a2ensite default-ssl
apache2ctl configtest

