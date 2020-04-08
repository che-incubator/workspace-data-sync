#!/bin/sh
#
# Copyright (c) 2019-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

ssh -i /.ssh/rsync.pub -q storage -p ${RSYNC_PORT} [[ -d /var/lib/storage/data/${CHE_WORKSPACE_ID} ]]
if [[ $? -eq 0 ]]; then
    rsync --recursive --quiet --rsh="ssh  -i /.ssh/rsync.pub -l user -p ${RSYNC_PORT} -o PasswordAuthentication=no  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" storage:/var/lib/storage/data/${CHE_WORKSPACE_ID}/  ${CHE_PROJECTS_ROOT}/
fi

