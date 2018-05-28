#!/bin/bash

PATH=$PATH:/usr/local/bin/
COMPOSE_INTERACTIVE_NO_CLI=1
export PATH
export COMPOSE_INTERACTIVE_NO_CLI
THIS_DIR=$(dirname $0)
#DO_SCRIPT='script --return -c'
DO_SCRIPT='/bin/bash'

touch $THIS_DIR/marker
#$THIS_DIR/update.sh
$DO_SCRIPT $THIS_DIR/backup.sh
$DO_SCRIPT $THIS_DIR/restore.sh

