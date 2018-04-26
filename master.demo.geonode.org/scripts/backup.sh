#!/bin/bash

# enable some debugging in bash
set -e
set -x

# common values

# locate docker-compose.yml file above this dir
WORKDIR=$(dirname $0)/../
# you can customize backup storage with BACKUP_DIR env var
_BACKUP_DIR=${BACKUP_DIR:-~/work/geonode/backup/}

# location of backup files
TSTAMP=$(date '+%Y%m%d')
BACKUP_DIR=${_BACKUP_DIR}/${TSTAMP}/
AUTH_BACKUP_PATH=${BACKUP_DIR}/auth.json
MONITORING_BACKUP_PATH=${BACKUP_DIR}/monitoring.json

# services/containers
BACKUP_SERVICE=backup
GEONODE_SERVICE=django
GEOSERVER_SERVICE=geoserver
NGINX_SERVICE=geonode
CONSUMERS_SERVICE=consumers
GSCONF_SERVICE=data-dir-conf
GEONODE_CONTAINER=${GEONODE_SERVICE}4demo_master


# do the work

# go to workdir, so we can use docker-compose
pushd $WORKDIR

# ensure we have target storage
mkdir -p ${BACKUP_DIR}

# dump auth and monitoring in geonode
docker-compose exec ${GEONODE_SERVICE} python manage.py dumpdata auth people.Profile -o  /root/auth.json
docker-compose exec ${GEONODE_SERVICE} python manage.py dumpdata monitoring -o /root/monitoring.json


# get data from container into storage
docker cp ${GEONODE_CONTAINER}:/root/auth.json $AUTH_BACKUP_PATH
docker cp ${GEONODE_CONTAINER}:/root/monitoring.json $MONITORING_BACKUP_PATH
docker exec ${GEONODE_CONTAINER} rm /root/auth.json
docker exec ${GEONODE_CONTAINER} rm /root/monitoring.json

# stop containers, remove GS-related containers and volumes
# here we're wiping all user-uploaded data
docker-compose stop
docker-compose rm -f ${NGINX_SERVICE}
docker-compose rm -f ${CONSUMERS_SERVICE}
docker-compose rm -f ${GEONODE_SERVICE}
docker-compose rm -f ${GEOSERVER_SERVICE}
docker-compose rm -f ${GSCONF_SERVICE}
docker volume prune -f

# restart compose
docker-compose up -d

# push auth data and restore them
docker cp ${AUTH_BACKUP_PATH} ${GEONODE_CONTAINER}:/root/
docker-compose exec ${GEONODE_SERVICE} python manage.py loaddata /root/auth.json





