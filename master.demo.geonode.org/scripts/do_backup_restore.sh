#!/bin/bash

PATH=$PATH:/usr/local/bin/
COMPOSE_INTERACTIVE_NO_CLI=1
export PATH
export COMPOSE_INTERACTIVE_NO_CLI
THIS_DIR=$(dirname $0)
#DO_SCRIPT='script --return -c'
DO_SCRIPT='/bin/bash'

touch $THIS_DIR/marker

# dump data first
$DO_SCRIPT $THIS_DIR/backup.sh
# cleanup existing containers/volumes
$DO_SCRIPT $THIS_DIR/cleanup.sh
# recreate containers
$DO_SCRIPT $THIS_DIR/update.sh
# restore data
$DO_SCRIPT $THIS_DIR/restore.sh

