#!/bin/bash

dbctl() {
	docker exec -ti mongo /mnt/mongo/open5gs-dbctl $*
}

# dbctl add <IMSI> <key> <opc>
# or
# dbctl add <IMSI> <ip> <key> <opc>

dbctl add 1 2 3
