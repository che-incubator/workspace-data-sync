#!/bin/sh
ssh -i /.ssh/rsync.pub -q storage -p ${RSYNC_PORT} [[ -d /var/lib/storage/data/${CHE_WORKSPACE_ID} ]]
if [[ $? -eq 0 ]]; then
    rsync --recursive --quiet --rsh="ssh  -i /.ssh/rsync.pub -l user -p ${RSYNC_PORT} -o PasswordAuthentication=no  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" storage:/var/lib/storage/data/${CHE_WORKSPACE_ID}/  ${CHE_PROJECTS_ROOT}/
fi

