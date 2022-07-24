#!/bin/bash


tempdate=$(expr $(date +%S) + 6)
truncate -s 0 /var/log/apache2/access.log
c=1
while true
do
    requests=$(cat /var/log/apache2/access.log | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')
    ipBans=($(echo -e $requests | tr " " "\n" | sort |uniq -c | awk '{split($0,a," "); if (a[1] >= 3)print a[2]}'))
    echo $ipBans
    if [ ${#ipBans[@]} -gt 0 ]; then
        for IP in "${ipBans[@]}"
        do
            if [ $(expr $(date +%M) + 3) -gt 59 ];then
                 iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 80 --match time --timestart $(date +%H:%M) --timestop $(date +%H:01) -j DROP
	         iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 443 --match time --timestart $(date +%H:%M) --timestop $(date +%H:01) -j DROP
	         $(echo "Apache Blocked IP Http/Https:"$IP>>logs/apacheBlocks.log)

	    elif [ $(expr $(date +%M) + 3) -lt 10 ];then
		iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 80 --match time --timestart $(date +%H:%M) --timestop $(date +%H:0$(expr $(date +%M) + 3)) -j DROP
		iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 443 --match time --timestart $(date +%H:%M) --timestop $(date +%H:0$(expr $(date +%M) + 3)) -j DROP
		$(echo "Apache Blocked IP Http/Https:"$IP>>logs/apacheBlocks.log)
	    else
		iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 80 --match time --timestart $(date +%H:%M) --timestop $(date +%H:$(expr $(date +%M) + 3)) -j DROP
		iptables -w -A INPUT -s $IP -p tcp -m tcp --dport 443 --match time --timestart $(date +%H:%M) --timestop $(date +%H:$(expr $(date +%M) + 3)) -j DROP
		$(echo "Apache Blocked IP Http/Https:"$IP>>logs/apacheBlocks.log)
	    fi
        done
    fi
    
    if [ $tempdate == $(date +%S) ];then
        truncate -s 0 /var/log/apache2/access.log
        tempdate=$(expr $(date +%S) + 6)
        if [ $tempdate -lt 10 ];then
             tempdate=0$(expr $(date +%S) + 6)
	elif [ $tempdate -gt 54 ];then
	     tempdate=01
        fi
    fi

done
