#!/bin/bash

# copy file to mongo container and setup bash function
docker cp open5gs/misc/db/open5gs-dbctl mongo:/data/db/
dbctl() {
	docker exec -ti mongo /data/db/open5gs-dbctl $*
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

osmohlr subscriber imsi 901700000038510 create
osmohlr subscriber imsi 901700000038510 update msisdn 510

dbctl add 901700000038510 D0B610FE4936B44E1DA671F16E3000B2 9B740A94C78BF61E0E99CD4044403912
dbctl type 901700000038510 1
dbctl update_apn 901700000038510 ims 0

dbctl add 901700000038511 11111111111111111111111111111111 22222222222222222222222222222222

