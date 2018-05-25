#!/bin/bash

THIS_DIR=$(dirname $0)

touch $THIS_DIR/marker
$THIS_DIR/update.sh
$THIS_DIR/backup.sh
$THIS_DIR/restore.sh

