#!/bin/bash

# copy file to mongo container and setup bash function
docker cp open5gs/misc/db/open5gs-dbctl mongo:/data/db/
dbctl() {
	docker exec -i mongo /data/db/open5gs-dbctl $*
}

osmohlr() {
	(echo enable ; echo $* ) | docker exec -i osmohlr telnet 0 4258
}

ensure_pyhss_running() {
	while ! curl -sfo /dev/null http://0.0.0.0:8080/docs/;
	do
		echo "PyHSS didn't start properly, restarting it."
		docker-compose -f docker_open5gs/deploy-all.yaml restart pyhss

		while ! docker top pyhss |grep -q "python3 hss.py";
		do
			echo "Waiting until container has started fully."
			sleep 1;
		done
		sleep 3
	done
}


ensure_pyhss_running


# actual provisioning
#

cat simcards.csv |grep -v '#' | while read msisdn imsi ki opc; 
do 
	echo "Provisioning IMSI $imsi (MSISDN=$msisdn)"

	# OsmoHLR
	osmohlr subscriber imsi $imsi create
	osmohlr subscriber imsi $imsi update msisdn $msisdn

	# WebUI
	dbctl add $imsi $ki $opc
	dbctl type $imsi 1
	dbctl update_apn $imsi ims 0

	# PyHSS
	./pyhss-tool.py -i $imsi -m $msisdn -k $ki -o $opc
done




