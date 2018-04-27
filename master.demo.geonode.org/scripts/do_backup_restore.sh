#!/bin/bash

THIS_DIR=$(dirname $0)

$THIS_DIR/backup.sh
$THIS_DIR/restore.sh
