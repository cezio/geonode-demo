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
python $THIS_DIR/manage_node.py load ${DUMP_DIR_DEST}
