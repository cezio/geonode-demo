#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

git pull || true

CMD="docker-compose build"

# CACHED controls if we need to do full or fast rebuild
if [ ! -n "${CACHED}" ]; then
    CMD="${CMD} --no-cache"
fi;

$CMD
