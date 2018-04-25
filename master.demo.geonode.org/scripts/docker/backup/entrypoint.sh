#!/bin/bash

THIS_DIR=$(dirname $0)

# call restore if needed
${THIS_DIR}/restore.sh

DUMP_DIR_BASE=${DUMP_DIR_BASE:-/mnt/volumes/backups/}
DUMP_DIR_DEST=${DUMP_DIR_BASE}/$(date '+%Y%m%d')/fixtures
DUMP_TEST_FILE=${DUM_DIR_DEST}/do.restore.marker

# add tasks to crontab and start cron

crontab -l | grep -i backup > /dev/null
has_backup=$?

if [ ! 0 -eq $has_backup ]; then
    crontab ${THIS_DIR}/crontab
    rm -f ${THIS_DIR}/crontab
fi;

rm ${DUMP_TEST_FILE} > /dev/null
restore_marker=$?

if [ $restore_marker = 0 ]; then
    ${THIS_DIR}/restore.sh "${DUMP_DIR_DEST}"
fi;

cmd="$@"

echo DOCKER_ENV=$DOCKER_ENV

if [ -z ${DOCKER_ENV} ] || [ ${DOCKER_ENV} = "development" ]
then
    echo "Executing standard Django server $cmd for Development"
else
    cmd="/usr/sbin/cron -f"
fi
echo "got command ${cmd}"
exec $cmd
