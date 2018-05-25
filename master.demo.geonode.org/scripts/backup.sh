#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

# dump auth and monitoring in geonode
docker-compose exec ${GEONODE_SERVICE} python manage.py dumpdata auth people.Profile -o  /root/auth.json
docker-compose exec ${GEONODE_SERVICE} python manage.py dumpdata monitoring -o /root/monitoring.json


# get data from container into storage
docker cp ${GEONODE_CONTAINER}:/root/auth.json $AUTH_BACKUP_PATH
docker cp ${GEONODE_CONTAINER}:/root/monitoring.json $MONITORING_BACKUP_PATH
docker exec ${GEONODE_CONTAINER} rm /root/auth.json
docker exec ${GEONODE_CONTAINER} rm /root/monitoring.json

# let's update code base and force rebuild
# note, we're in scripts/.. dir, need to adjust paths
scripts/update.sh

# stop containers, remove GS-related containers and volumes
# here we're wiping all user-uploaded data
docker-compose stop
docker-compose rm -f ${NGINX_SERVICE}
docker-compose rm -f ${CONSUMERS_SERVICE}
docker-compose rm -f ${GEONODE_SERVICE}
docker-compose rm -f ${GEOSERVER_SERVICE}
docker-compose rm -f ${GSCONF_SERVICE}
docker-compose rm -f ${DB_SERVICE}
docker volume prune -f
