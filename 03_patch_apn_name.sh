#!/bin/bash -ex

APN=yolo.ninjas.apn

for i in dns icscf pcrf pcscf pyhss scscf smsc;
do
	for f in docker_open5gs/$i/*;
	do
		if [ -f $f ];
		then
			sed -i "s:ims.mnc:$APN.mnc:g" $f
		fi
	done
done

for i in smf upf;
do
	for f in docker_open5gs/$i/*;
	do
		if [ -f $f ];
		then
			sed -i "s:ims:$APN:g" $f
		fi
	done
done
