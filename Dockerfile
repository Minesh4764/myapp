FROM python:3.9 AS builder
COPY /root/.s3cfg /root/.s3cfg

FROM python:3.9

RUN apt-get update && apt-get install -y s3cmd cron
RUN service cron start

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py /app/
COPY my-cron-job /etc/cron.d/
#COPY .s3cfg /root/.s3cfg

RUN chmod 0644 /etc/cron.d/my-cron-job
RUN touch /var/log/testlog.log

RUN echo "*/1 * * * * root /usr/local/bin/python /app/app.py >> /var/log/testlog.log 2>&1 && s3cmd put /var/log/testlog.log s3://testpipeline/Dockerlogs/doclogs.log" > /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN crontab /etc/cron.d/my-cron-job

CMD cron && tail -f /var/log/testlog.log