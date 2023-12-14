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
iptables -t nat -I POSTROUTING -o $IF_INTERNET -j MASQUERADE

source docker_open5gs/.env
echo "Setting a route to the ims and internet interfaces for their respective IP ranges"
ip route add $UE_IPV4_INTERNET via $UPF_IP
ip route add $UE_IPV4_IMS via $UPF_IP
