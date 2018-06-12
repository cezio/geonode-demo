#!/bin/bash

source $(dirname $0)/vars.sh

# restart compose
docker-compose up -d

# copy auth.json to volume, so it will be restored by tasks.py
docker cp ${AUTH_BACKUP_PATH} ${GEONODE_CONTAINER}:/mnt/volumes/statics/
