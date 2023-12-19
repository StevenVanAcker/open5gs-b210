#!/bin/bash

source docker_open5gs/.env
echo "Setting a route to the ims and internet interfaces for their respective IP ranges"
sudo ip route add $UE_IPV4_INTERNET via $UPF_IP
sudo ip route add $UE_IPV4_IMS via $UPF_IP
