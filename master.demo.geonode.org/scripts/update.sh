#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

git pull

CMD="docker-compose build"

if [ ! -n "${CACHED}" ];
    CMD="${CMD} --no-cache"
fi;

$CMD
