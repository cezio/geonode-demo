#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

# dump auth and monitoring in geonode
docker-compose exec -T ${GEONODE_SERVICE} python manage.py dumpdata people.Profile auth.Group groups -o /root/auth.json
docker cp ${GEONODE_CONTAINER}:/root/auth.json $AUTH_BACKUP_PATH
docker exec ${GEONODE_CONTAINER} rm /root/auth.json

docker-compose exec -T ${GEONODE_SERVICE} python manage.py dumpdata monitoring -o /root/monitoring.json
docker cp ${GEONODE_CONTAINER}:/root/monitoring.json $MONITORING_BACKUP_PATH
docker exec ${GEONODE_CONTAINER} rm /root/monitoring.json
