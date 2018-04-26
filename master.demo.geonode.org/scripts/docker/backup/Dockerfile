FROM debian:stretch

# backup/restore container

# Install deps
RUN apt-get update; apt-get install -q -y openssl\
        ca-certificates postgresql-client wget cron\
        rsync procps python-pip

RUN pip install docker

COPY *.sh /root/
COPY *.py /root/


RUN chmod +x /root/*.sh
RUN chmod +x /root/*.py
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron

COPY crontab /root/crontab

ENTRYPOINT /root/entrypoint.sh
