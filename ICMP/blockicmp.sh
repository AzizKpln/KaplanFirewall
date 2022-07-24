iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT A
