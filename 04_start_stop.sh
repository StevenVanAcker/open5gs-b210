#!/bin/bash

cmd=$1

if [ "$cmd" = "stop" ];
then
	echo "Stopping..."
	docker-compose -f docker_open5gs/deploy-all.yaml down
	docker-compose -f docker_open5gs/srsenb.yaml down
	exit 0
fi


if [ "$cmd" = "start" -o "$cmd" = "cleanstart" ];
then
	if [ "$cmd" = "cleanstart" ];
	then
		echo "Removing all volumes and networks"
		docker-compose -f docker_open5gs/deploy-all.yaml down -v
		docker-compose -f docker_open5gs/srsenb.yaml down -v

		echo "Resetting docker repository"
		pushd docker_open5gs
		git clean -dfX
		popd
	fi

	echo "Starting..."

	( 
		while ! docker network inspect docker_open5gs_default &> /dev/null; 
		do 
			echo "Network does not exist yet."; 
			sleep 1; 
		done 
		docker-compose -f docker_open5gs/srsenb.yaml up
	) &

	docker-compose -f docker_open5gs/deploy-all.yaml up 

	exit 0
fi

echo "Usage: $0 <start|cleanstart|stop>"
exit 1
