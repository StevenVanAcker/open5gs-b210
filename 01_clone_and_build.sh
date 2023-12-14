#!/bin/bash -e

# https://open5gs.org/open5gs/docs/tutorial/03-VoLTE-dockerized/

# Step 1: Prepare SIM cards for VoLTE
# ...

# Step 2: Build Open5GS, Kamailio with docker-compose
git clone https://github.com/herlesupreeth/docker_open5gs
pushd docker_open5gs

pushd base
docker build --no-cache --force-rm -t docker_open5gs .
popd

pushd ims_base
docker build --no-cache --force-rm -t docker_kamailio .
popd

pushd srslte
docker build --no-cache --force-rm -t docker_srslte .
popd

# Step 3: Configuring your setup
cat .env | sed 's:^MCC=.*:MCC=901:' \
		 | sed 's:^MNC=.*:MNC=70:' \
		 | sed 's:^TEST_NETWORK=.*:TEST_NETWORK=172.22.0.0/24:' \
		 | sed 's:^DOCKER_HOST_IP=.*:DOCKER_HOST_IP=192.168.130.1:' \
		 > .env2

# only update .env if there is a change
diff .env .env2 || cp .env2 .env
rm -f .env2

# Magic step 3.5: make sure NAT is enabled for ims APN. This is a dirty way
# to abuse the ims APN as if it were the internet APN, because the internet
# APN doesn't seem to work at all
sed -i "s:--nat_rule 'no'::" upf/upf_init.sh

# Step 4: Building 4G/5G Core + IMS related components images
source .env
docker-compose -f deploy-all.yaml build

# Step 5: (Optional) Run srsENB in a separate container
docker-compose -f srsenb.yaml build


popd

# Step 6: Configuration and register two UE (prepare provisioning)
test -d open5gs || git clone https://github.com/open5gs/open5gs.git

