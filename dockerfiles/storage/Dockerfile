#!/bin/bash
#
# Copyright (c) 2019-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

FROM alpine:3.11

COPY  entrypoint.sh /usr/local/bin

RUN mkdir  /var/run/sshd /.ssh && \
    # Change permissions to let any arbitrary user
    for f in  "/etc/passwd" "/.ssh" "/var/run/sshd" ; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
            rsync \
            openssh \
            ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/* \
    && chmod 0550 /.ssh \
    && sed -i s/root:!/"root:*"/g /etc/shadow \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 2222
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

 
