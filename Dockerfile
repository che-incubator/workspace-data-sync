FROM alpine:3.11

ENV USER=user
ENV UID=12345
ENV GID=23456

# Add user that will be able to start machine-exec-binary but nothing more
# the result will be propagated then into scratch image
# See https://stackoverflow.com/a/55757473/12429735RUN
RUN addgroup --gid "$GID" "$USER" \
       && adduser \
       --disabled-password \
       --gecos "" \
       --home "$(pwd)" \
       --ingroup "$USER" \
       --no-create-home \
       --uid "$UID" \
       "$USER"

RUN mkdir  /etc/ssh /var/run/sshd /.ssh && \
    # Change permissions to let any arbitrary user
    for f in  "/etc/passwd" "/etc/ssh"  "/.ssh" "/var/run/sshd" ; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            curl \
            openssh \
            ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

#cron task not work in openshift in case https://github.com/gliderlabs/docker-alpine/issues/381
#so will used  supercronic https://github.com/aptible/supercronic
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
 
COPY entrypoint.sh /usr/local/bin
COPY restore.sh /bin/restore.sh
COPY backup.sh /bin/backup.sh
RUN chmod +x /bin/restore.sh
RUN chmod +x /bin/backup.sh
# Copy cron file to the cron.d directory
COPY cron/backup-cron-job /tmp/crontabs/backup-cron-job
# Give execution rights on the cron job
RUN chmod 0644 /tmp/crontabs/backup-cron-job
# Apply cron job
#RUN crontab /tmp/crontabs/user

COPY rsync /.ssh/rsync.pub
RUN chmod 0550 /.ssh
RUN chmod 0550 /.ssh/rsync.pub
# make sure we get fresh keys
RUN sed -i s/root:!/"root:*"/g /etc/shadow

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
