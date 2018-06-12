#!/bin/bash
set -e

/usr/local/bin/invoke update

source $HOME/.override_env

echo DATABASE_URL=$DATABASE_URL
echo GEODATABASE_URL=$GEODATABASE_URL
echo SITEURL=$SITEURL
echo ALLOWED_HOSTS=$ALLOWED_HOSTS
echo GEOSERVER_PUBLIC_LOCATION=$GEOSERVER_PUBLIC_LOCATION

/usr/local/bin/invoke waitfordbs

echo "waitfordbs task done"

echo "running migrations"
/usr/local/bin/invoke migrations
echo "migrations task done"

if [ ! -e "/mnt/volumes/statics/geonode_init.lock" ]; then
    /usr/local/bin/invoke statics
    /usr/local/bin/invoke prepare
    echo "prepare task done"
    /usr/local/bin/invoke fixtures
    echo "fixture task done"
fi
/usr/local/bin/invoke initialized

set -e
echo DOCKER_ENV=$DOCKER_ENV

echo "got command ${CMD}"
exec $CMD
