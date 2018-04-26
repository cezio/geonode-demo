#!/bin/bash


THIS_DIR=$(dirname $0)
DUMP_DIR_BASE=${DUMP_DIR_BASE:-/mnt/volumes/backups/}
DUMP_DIR_DEST=${DUMP_DIR_BASE}/$(date '+%Y%m%d')/fixtures
DUMP_TEST_FILE=${DUM_DIR_DEST}/do.restore.marker

mkdir -p ${DUMP_DIR_DEST}
python $THIS_DIR/manage_node.py dump $DUMP_DIR_DEST
#python manage.py dumpdata monitoring > ${DUMP_DIR_DEST}/monitoring.json
#python manage.py dumpdata auth profiles > ${DUMP_DIR_DEST}/auth.json
touch ${DUMP_TEST_FILE}

DO_RESTART="true" ${THIS_DIR}/restore.sh "${DUMP_DIR_DEST}"

