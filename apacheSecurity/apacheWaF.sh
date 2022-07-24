#!/bin/bash/


#necessery package installation
sudo apt install libapache2-mod-security2 -y
sudo apt install git -y
a2enmod headers && systemctl restart apache2
sudo rm -rf /usr/share/modsecurity-crs/
git clone https://github.com/coreruleset/coreruleset /usr/share/modsecurity-crs
mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf &> /dev/null
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/gi' /etc/modsecurity/modsecurity.conf



