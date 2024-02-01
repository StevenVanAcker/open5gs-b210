#!/bin/bash -ex

APN=$(cat APN-NAME)

cd docker_open5gs

for i in dns icscf pcrf pcscf pyhss scscf smsc;
do
	for f in $i/*;
	do
		if [ -f $f ];
		then
			git checkout $f
			sed -i "s:ims.mnc:$APN.mnc:g" $f
		fi
	done
done

for i in smf upf;
do
	for f in $i/*;
	do
		if [ -f $f ];
		then
			git checkout $f
			sed -i "s:ims:$APN:g" $f
		fi
	done
done
