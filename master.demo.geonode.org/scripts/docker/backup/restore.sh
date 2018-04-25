#!/bin/bash

if [ -n ${1} ]; then
    THIS_DIR=$(dirname $0)
    DUMP_DIR_BASE=${DUMP_DIR_BASE:-/mnt/volumes/backups/}
    DUMP_DIR_DEST=${DUMP_DIR_BASE}/$(date '+%Y%m%d')/fixtures
    DUMP_TEST_FILE=${DUM_DIR_DEST}/do.restore.marker
else 
    DUMP_DIR_DEST=${1}
fi;

# recreate and restart nodes

rm -fr /mnt/volumes/statics/*
rm -fr /mnt/volumes/geoserver-data/
#rm -fr /mnt/volumes/pg-data/*

#echo "drop database ${GEONODE_DATABASE}" | psql -U postgres -h db 
#echo "drop database ${GEONODE_DATABASE_DATA}" | psql -U postgres -h db 


python $THIS_DIR/manage_node.py restart ${DUMP_DIR_DEST}
python $THIS_DIR/manage_node.py restore ${DUMP_DIR_DEST}
