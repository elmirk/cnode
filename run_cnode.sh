#!/bin/bash

#run cnode container on main prod server castor
docker run -dit --log-driver=json-file --log-opt max-size=10m --log-opt max-file=15 --name=cnode --ipc="host" --network="host" cnode:0.0.0
