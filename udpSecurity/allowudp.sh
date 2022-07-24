#!/bin/bash

iptables -F
iptables -X
iptables -t mangle -F
iptables -t mangle -X

sudo apt update
