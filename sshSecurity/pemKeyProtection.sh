#!/bin/bash
lightblue=`tput setaf 14`
green=`tput setaf 46`
RED=`tput setaf 196`
yellow=`tput setaf 11`
purple=`tput setaf 129`
reset=`tput sgr0`
apt install curl -y 

echo -e "${lightblue}[+]${green}Rsa Key Is Being Generated. This might take a while.."
$(ssh-keygen -t rsa -f $HOME/.ssh/id_rsa)
$(chmod 700 $HOME/.ssh)
$(cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys)
$(mv $HOME/.ssh/id_rsa $HOME/.ssh/id.pem)
$(cp $HOME/.ssh/id.pem sshSecurity/pemKey/)
$(chmod 600 $HOME/.ssh/authorized_keys)
echo -e "${lightblue}[+]${green}Your PEM key has been generated. It's located in '$(pwd)/pemKey/id.pem\n\n"
echo -e "${yellow}[*]${green}Please enter this command before we continue on your local computer"
echo -e "${lightblue}[+]${green}scp $(whoami)@$(curl ifconfig.me -s):$(pwd)/sshSecurity/pemKey/id.pem ."
echo -e "${lightblue}[+]${green}Press enter after issuing the command above on your LOCAL PC!\n"
read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" ask

echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
sed -i "s/#StrictModes yes/StrictModes yes/gi" /etc/ssh/sshd_config
systemctl restart ssh


echo -e "${lightblue}[+]${green}Password Login Disabled!"
echo -e "${lightblue}[+]${green}Only PEM Key Auth Is Allowed!"
echo -e "${lightblue}[+]${green}Command To Connect The SSH: ssh -i id.pem $(whoami)@$(hostname)"
