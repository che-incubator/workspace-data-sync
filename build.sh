#!/bin/bash
#
# Copyright (c) 2012-2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
#include common scripts
. ./common.sh

usage="$(basename "$0") -- script for compile Go source and build docker images

usage:
    -t,--tag             tag name for docker images (default: latest)
    -o,--organization    organization name for docker images (default: che-incubator)
    -h,--help            show this help text"

while [[ $# -gt 0 ]]
do
    key="${1}"
    case $key in
    -t|--tag)
        TAG="${2}"
        shift
        shift
        ;;
    -o|--organization)
        ORGANIZATION="${2}"
        shift
        shift
        ;;
    -h|--help)
        echo "$usage"
        exit 0
        ;;
    *) printf "illegal option: -%s\n" "$key"
       echo "$usage"
       exit 1
       ;;
    esac
done

#default
if [[ -z "$TAG" ]]
then TAG="latest"
fi
if [[ -z "$ORGANIZATION" ]]
then ORGANIZATION="che-incubator"
fi

compile;
dockerBuild "$TAG" "${ORGANIZATION}";
