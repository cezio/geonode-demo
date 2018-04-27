#!/bin/bash

# include common vars
source $(dirname $0)/vars.sh

git pull
docker-compose build --no-cache
