#!/bin/bash

sh ./install/docker.sh
docker swarm init
WorkerToken=${docker swarm join-token -q worker}
