#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

# dump auth and monitoring in geonode
docker-compose exec -T ${GEONODE_SERVICE} python manage.py dumpdata auth people.Profile -o  /root/auth.json
docker-compose exec -T ${GEONODE_SERVICE} python manage.py dumpdata monitoring -o /root/monitoring.json


# get data from container into storage
docker cp ${GEONODE_CONTAINER}:/root/auth.json $AUTH_BACKUP_PATH
docker cp ${GEONODE_CONTAINER}:/root/monitoring.json $MONITORING_BACKUP_PATH
docker exec ${GEONODE_CONTAINER} rm /root/auth.json
docker exec ${GEONODE_CONTAINER} rm /root/monitoring.json

