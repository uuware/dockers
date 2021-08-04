#!/usr/bin/env bash

#
# Build and push the images.
#
# Usage: build-push-images.sh mydockerhubuser/myreponame
# E.g. build-push-images.sh eugenesia/phpfarm
#
# Turn on Docker experimental mode to enable the --squash functionality.
# See https://github.com/docker/docker/tree/master/experimental
#

# Get the Docker hub user/repo so we know how to tag the built images and push
# them to Docker hub.
if [ -z "$1" ]; then
  hubUserRepo='eugenesia/phpfarm'
  echo "hubuser/repo not provided, defaulting to $hubUserRepo"
else
  hubUserRepo="$1"
fi

# Be verbose.
set -vx

# Need to prefix with Docker.io to build on CircleCI.
docker build --squash -t ${hubUserRepo}:jessie -t \
  ${hubUserRepo}:latest -f Dockerfile-Jessie . \
  > /tmp/build-jessie.log 2>&1
docker push ${hubUserRepo}:jessie
docker push ${hubUserRepo}:latest

# Disable verbose.
set +vx

