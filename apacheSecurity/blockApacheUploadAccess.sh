#!/bin/bash



rm /etc/apache2/apache2.conf && cp apacheSecurity/configFiles/apache2.conf /etc/apache2/

cp apacheSecurity/configFiles/.htaccess /var/www/html/
