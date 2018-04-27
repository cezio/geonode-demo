#!/bin/bash

source $(dirname $0)/vars.sh

# restart compose
docker-compose up -d

until docker-compose exec ${DB_SERVICE} psql -U postgres -d geonode -c 'select * from people_profile;' ; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done


# push auth data and restore them
docker cp ${AUTH_BACKUP_PATH} ${GEONODE_CONTAINER}:/root/
docker-compose exec ${GEONODE_SERVICE} python manage.py loaddata /root/auth.json
