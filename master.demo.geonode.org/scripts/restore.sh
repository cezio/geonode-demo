#!/bin/bash

source $(dirname $0)/vars.sh

# restart compose
docker-compose up -d

until docker-compose exec ${GEONODE_SERVICE} ps -aux | grep uwsgi > /dev/null ; do
  sleep 1
done

echo "restoring data from ${AUTH_BACKUP_PATH}"

# push auth data and restore them
docker cp ${AUTH_BACKUP_PATH} ${GEONODE_CONTAINER}:/root/
docker-compose exec ${GEONODE_SERVICE} python manage.py loaddata /root/auth.json
