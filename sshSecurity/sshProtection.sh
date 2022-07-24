#!/bin/bash
IPTABLES="/usr/sbin/iptables"
truncate -s 0 /var/log/auth.log
truncate -s 0 logs/currentLogins.log


if [ -s $(pwd)"/"loginScreen/_check_ ];then
     echo "Banner "$(pwd)/loginScreen/warning.net>>/etc/ssh/sshd_config
     rm loginScreen/_check_ && systemctl restart sshd
fi

while true
    do
        if [ -s /var/log/auth.log ];then
            if [[ $(grep "Failed password" /var/log/auth.log | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | uniq -d | tail -1) != "" ]]
            then
                 blockIP=$(grep "Failed password" /var/log/auth.log | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | uniq -d | tail -1)
                 $(echo "Blocked IP:"$blockIP >> logs/sshBlocks.log)
                 ipToBlock=$(truncate -s -1 logs/blocks.log | grep "Failed password" /var/log/auth.log | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | uniq -d | tail -1)
                 if [ $(expr $(date +%M) + 3) -lt 7 ];then 
                     $IPTABLES -w -A INPUT -s $blockIP --match time --timestart $(date +%H:%M) --timestop $(date +%H:0$(expr $(date +%M) + 3)) -j DROP
                     echo "temp" > /var/log/auth.log
                 elif [ $(expr $(date +%M) + 3) -gt 59 ];then
                     $IPTABLES -w -A INPUT -s $ipToBlock --match time --timestart $(date +%H:%M) --timestop $(date +%H:03) -j DROP
                     echo "temp" > /var/log/auth.log
                 else
                     $IPTABLES -w -A INPUT -s $ipToBlock --match time --timestart $(date +%H:%M) --timestop $(date +%H:0$(expr $(date +%M) + 3)) -j DROP
                     echo "temp" > /var/log/auth.log
                 fi 

                 #if 
                 #$IPTABLES -A INPUT -s $ipToBlock --match time --timestart $(date +%H:%M) --timestop $(date +%H:$(expr $(date +%M) + 3)) -j DROP
                # echo "temp" > /var/log/auth.log
            fi
        else
	    sleep 0.1
            continue
        fi
    done

