#!/bin/bash
lightblue=`tput setaf 14` 
green=`tput setaf 46`     
RED=`tput setaf 196`      
yellow=`tput setaf 11`    
purple=`tput setaf 129`   
reset=`tput sgr0`
#banner
echo -e "${green} $(cat banner/banner)\n"
echo -e "\t${lightblue}[${RED}1${lightblue}]${green}SSH Protection - Password Brute Force Protection"
echo -e "\t${lightblue}[${RED}2${lightblue}]${green}SSH Protection - Pem Key Protection"
echo -e "\t${lightblue}[${RED}3${lightblue}]${green}APACHE Protection - IP Ban Too Many Requests"
echo -e "\t${lightblue}[${RED}4${lightblue}]${green}APACHE Protection - WaF & Secure Apache"
echo -e "\t${lightblue}[${RED}5${lightblue}]${green}IP Protection - Cloudflare"
echo -e "\t${lightblue}[${RED}6${lightblue}]${green}Block ICMP Requests"
echo -e "\t${lightblue}[${RED}7${lightblue}]${green}Block UDP Requests"
read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" ask
if (( $ask==1 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option will protect your server from SSH BRUTE FORCE ATTACK.\n\n"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    nohup  bash sshSecurity/sshProtection.sh &
    echo -e "${lightblue}[+]${green} Firewall Rules Has Been Set Up Successfully!"
elif (( $ask==2 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option will block password logins, it'll generate you a PEM key. And logins will be accepted with that key only!\n\n"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    bash sshSecurity/pemKeyProtection.sh
    echo -e "${lightblue}[+]${green}It's Done!." 
    
elif (( $ask==3 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option will block too many requests. You'll also be protected against Directory Fuzzing."
    echo -e "${RED}[!]${yellow}This option is for apache only. Don't use it for nginx!\n\n"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    nohup bash apacheSecurity/apacheProtection.sh &
    echo -e "${lightblue}[+]${green}It's Done!." 
elif (( $ask==4 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option will protect your server against SQL injection,XSS,LFI,RFI etc."
    echo -e "${lightblue}[+]${green}This option will also block users to access your upload page and protect you against current apache vulnerabilities."
    echo -e "${RED}[!]${yellow}This option is for apache only. Don't use it for nginx!\n\n"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    
    bash apacheSecurity/apacheWaF.sh
    bash apacheSecurity/apacheCode.sh
    echo -e "${lightblue}[+]${green}It's Done!." 
elif (( $ask==5 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option will block all requests that's been sent directly."
    echo -e "${lightblue}[+]${green}Your origin server will accept requests from Cloudflare only. "
    echo -e "${RED}[!]${yellow}Don't use this option if your origin server is not behind Cloudflare!\n\n"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    
    bash CFSec/cfsec.sh
    echo -e "${lightblue}[+]${green}It's Done!." 

elif (( $ask==6 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option block all ICMP requests for security. Note: This option may cause network issues in your server"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    bash ICMP/blockicmp.sh
    echo -e "${lightblue}[+]${green}It's Done!." 
elif (( $ask==7 ));then
    clear
    echo -e "${green} $(cat banner/banner)\n"
    echo -e "${lightblue}[+]${green}This option block all UDP requests. It'll prevent UDP based brute force attacks."
    echo -e "${RED}[!]${yellow}Note: Using this option will block you using UDP. It means you cannot use APT for download/update/upgrade"
    echo -e "${RED}[!]${yellow}Note2: You can remove all rules  with running this command:bash udpSecurity/allowudp.sh"
    echo -e "${lightblue}Press enter to continue"
    read -p "$(echo -e '\n')${lightblue}KaplanFirewall${purple}@${green}$(whoami)${RED}[${reset}~${RED}]${purple}" temp
    bash udpSecurity/blockudp.sh
    echo -e "${lightblue}[+]${green}It's Done!." 
fi
