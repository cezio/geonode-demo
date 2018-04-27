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
DB_SERVICE=db

DEPLOYMENT=4demo_master

GEONODE_CONTAINER=${GEONODE_SERVICE}${DEPLOYMENT}
DB_CONTAINER=${DB_SERVICE}${DEPLOYMENT}


# do the work

# go to workdir, so we can use docker-compose
pushd $WORKDIR

# ensure we have target storage
mkdir -p ${BACKUP_DIR}

