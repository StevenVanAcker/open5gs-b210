#!/bin/bash

echo "Disabling firewall"
ufw disable

echo "Allowing IP forwarding"
sysctl -w net.ipv4.ip_forward=1

echo "Determining internet-facing interface"
IF_INTERNET=$(ip route ls|grep default|sed 's:.* dev ::'|awk '{print $1}')

if [ "$IF_INTERNET" = "" ];
then
	echo "No interface with default gateway. You need to connect to the internet"
	exit 1
fi

echo "Setting up masquerading on $IF_INTERNET"
iptables-restore <<EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o $IF_INTERNET -j MASQUERADE
COMMIT
EOF
