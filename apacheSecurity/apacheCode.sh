#!/bin/bash

lightblue=`tput setaf 14` 
green=`tput setaf 46`     
RED=`tput setaf 196`      
yellow=`tput setaf 11`    
purple=`tput setaf 129`   
reset=`tput sgr0`
echo -e "Do You Have PhpMyAdmin Installed?[Y/N]\n\n"
read -p "$(echo -e '\n\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" ask
if [ $ask == "Y" ] || [ $ask =="YES" ];then
	echo "Include /etc/phpmyadmin/apache.conf" >> configFiles/apache2.conf

fi

cp apacheSecurity/configFiles/apache2.conf /etc/apache2/apache2.conf
cp apacheSecurity/configFiles/000-default.conf /etc/apache2/sites-enabled/000-default.conf

systemctl restart apache2
echo -e "Everything Looks Ok! WaF has been set up\n\n"
