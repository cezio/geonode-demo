#!/bin/bash

source $(dirname $0)/vars.sh

# restart compose
docker-compose up -d

# waitfordb task - wait for creation of db 
while (docker-compose exec -T ${GEONODE_SERVICE} ps -aux | grep invoke) > /dev/null; do
  sleep 5
done

# wait for uwsgi - this should be up and running after migration
until (docker-compose exec -T ${GEONODE_SERVICE} ps -aux | grep uwsgi) > /dev/null ; do
  sleep 5
done

echo "restoring data from ${AUTH_BACKUP_PATH}"

# push auth data and restore them
docker cp ${AUTH_BACKUP_PATH} ${GEONODE_CONTAINER}:/root/
docker-compose exec -T ${GEONODE_SERVICE} python manage.py loaddata /root/auth.json
