#!/bin/bash
#
# Copyright (c) 2012-2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

IMAGE_AGENT=che-sidecar-workspace-data-sync
IMAGE_STORAGE=che-workspace-data-sync-storage
TAG=$1
ORGANIZATION=$2
REPOSITORY=$3

function compile() {
  echo "Compile file sync progress watcher binary from source code"
  $(GOOS=linux go build -o ./dockerfiles/agent/scripts/watcher ./watcher/watcher.go)
  if [ $? != 0 ]; then
    echo "Failed to compile code"
    exit 0
  fi
  echo "Compilation successfully completed"
}

function dockerBuild() {
  printf "Build docker image %s/%s/%s:%s \n" "$REPOSITORY" "$ORGANIZATION" "$IMAGE_AGENT" "$TAG";
  docker build -t "$REPOSITORY/$ORGANIZATION/$IMAGE_AGENT:$TAG" ./dockerfiles/agent
  if [ $? != 0 ]; then
    printf "Failed build docker image %s/%s/%s:%s \n" "$REPOSITORY" "$ORGANIZATION" "$IMAGE_AGENT" "$TAG";
    exit 0
  fi

  printf "Build docker image %s/%s/%s:%s \n" "$REPOSITORY" "$ORGANIZATION" "$IMAGE_STORAGE" "$TAG";
  docker build -t "$REPOSITORY/$ORGANIZATION/$IMAGE_STORAGE:$TAG" ./dockerfiles/storage
  if [ $? != 0 ]; then
    printf "Failed build docker image %s/%s/%s:%s \n" "$REPOSITORY" "$ORGANIZATION" "$IMAGE_STORAGE" "$TAG";
    exit 0
  fi

  echo "Build images successfully completed"
}
