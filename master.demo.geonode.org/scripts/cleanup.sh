#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

# stop containers, remove GS-related containers and volumes
# here we're wiping all user-uploaded data
docker-compose stop
docker-compose rm -f
docker volume prune -f
