#!/bin/sh
#
# Copyright (c) 2019-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

rsync --recursive --quiet --rsh="ssh  -i /.ssh/rsync.pub -l user -p ${RSYNC_PORT} -o PasswordAuthentication=no  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${CHE_PROJECTS_ROOT}/ storage:/var/lib/storage/data/${CHE_WORKSPACE_ID}
