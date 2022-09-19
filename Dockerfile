FROM ubuntu:20.04

ENV PUBLIC_KEY=

EXPOSE 2222

RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl supervisor openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisord
RUN mkdir -p /etc/supervisor/conf.d

RUN sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./ssh.conf /etc/supervisor/conf.d/ssh.conf
COPY ./start_ssh.sh /root/start_ssh.sh

RUN mkdir /root/.ssh
RUN touch /root/.ssh/authorized_keys

RUN service ssh start

CMD ["/usr/bin/supervisord"]
