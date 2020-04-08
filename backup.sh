#!/bin/sh
rsync --recursive --quiet --rsh="ssh  -i /.ssh/rsync.pub -l user -p ${RSYNC_PORT} -o PasswordAuthentication=no  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${CHE_PROJECTS_ROOT}/ storage:/var/lib/storage/data/${CHE_WORKSPACE_ID}
