#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

git pull || true

CMD="docker-compose build"

# REBUILD controls if we need to do full or fast rebuild
if [ -n "${REBUILD}" ]; then
    # do not log build, just errors
    CMD="${CMD} --no-cache"
fi;

# discard usual output
$CMD > /dev/null
