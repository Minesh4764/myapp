
FROM python:3.9 AS builder
COPY /root/.s3cfg /root/.s3cfg

FROM python:3.9

RUN apt-get update && apt-get install -y cron s3cmd

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py /app/
COPY my-cron-job /etc/cron.d/

RUN chmod 0644 /etc/cron.d/my-cron-job
RUN touch /var/log/cron.log
# USER root
# ARG S3CFG_LOCATION=/root/.s3cfg
# COPY $S3CFG_LOCATION /root/.s3cfg

RUN echo "*/1 * * * * root /usr/local/bin/python /app/app.py >> /var/log/cron.log 2>&1 && s3cmd --access_key=DO00QTR2VTHEK2R9URFJ --secret_key=Qrv4BQUStDQCCQ0wR97WvS0TDtrHGyJwChEet11Cu70 --endpoint-url=https://testpipeline.nyc3.digitaloceanspaces.com put /var/log/cron.log s3://testingpipeline4536/logs/" > /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN crontab /etc/cron.d/my-cron-job

CMD cron && tail -f /var/log/cron.log
