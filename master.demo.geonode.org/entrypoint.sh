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

if [ 'true' != ${IS_CELERY} ]; then
    echo "running migrations"
    /usr/local/bin/invoke migrations
    /usr/local/bin/invoke statics
    echo "migrations task done"
    /usr/local/bin/invoke prepare
    echo "prepare task done"
    # load fixtures only if there's no auth data
    set +e
    python manage.py dumpdata auth | grep -i admin > /dev/null
    has_fixtures=$?
    if [ $has_fixtures -eq 1 ]; then 
        /usr/local/bin/invoke fixtures
        echo "fixture task done"
    fi;
fi;

set -e
echo DOCKER_ENV=$DOCKER_ENV

echo "got command ${CMD}"
exec $CMD
