FROM alpine:3.11

RUN mkdir  /etc/ssh /var/run/sshd /.ssh && \
    # Change permissions to let any arbitrary user
    for f in  "/etc/passwd" "/etc/ssh" "/.ssh" "/var/run/sshd" ; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh \
            ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

ADD entrypoint.sh /usr/local/bin
#COPY rsync.pub /.ssh/authorized_keys
RUN chmod 0550 /.ssh

# make sure we get fresh keys
RUN sed -i s/root:!/"root:*"/g /etc/shadow
EXPOSE 2222
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

 
