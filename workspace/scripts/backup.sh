#!/bin/sh
#
# Copyright (c) 2019-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

USER_NAME="user"
##### SSH options #####
SSH_OPTIONS=""
# Add SSH connection options
SSH_OPTIONS=" ${SSH_OPTIONS} -i /etc/ssh/private/rsync-via-ssh -l ${USER_NAME} -p ${RSYNC_PORT}"
# Disable password authentication since we use key-based auth
SSH_OPTIONS=" ${SSH_OPTIONS} -o PasswordAuthentication=no"
# Disable hosts fingerprint checking because it may fail due to
# starting different containers on the same ports after some period
SSH_OPTIONS=" ${SSH_OPTIONS} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
# Set SSH logging level to make it possible to investigate problems
#SSH_OPTIONS=" ${SSH_OPTIONS} -o LogLevel=${SSH_LOG_LEVEL}"

##### Rsync options #####
RSYNC_OPTIONS=""
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --quiet"
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --recursive"
# Throughput limit for rsync
#RSYNC_OPTIONS+=" ${RSYNC_OPTIONS} --bwlimit=${RSYNC_BACKUP_BWLIMIT}"
# Sync modification timestamps to optimise transfer of not modified files.
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --times"
# Do not remove partially transferred files if transfer is interrupted. Make subsequent transfers faster.
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --partial"
# Delete files/folders on receiving side if they are not present on sending side.
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --delete"
# Preserve sym links in a safe way
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --links --safe-links"
# Transition of ownership and permissions
RSYNC_OPTIONS=" ${RSYNC_OPTIONS} --owner --group --numeric-ids --perms"

rsync  ${RSYNC_OPTIONS} --rsh="ssh  ${SSH_OPTIONS}"  ${CHE_PROJECTS_ROOT}/ storage:/var/lib/storage/data/${CHE_WORKSPACE_ID}
