#!/bin/bash

iptables -A INPUT -p udp -j DROP
