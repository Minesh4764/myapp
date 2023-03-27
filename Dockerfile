


FROM python:3.9

RUN apt-get update && apt-get install -y s3cmd cron
RUN service cron start
ARG S3_ACCESS_KEY
ARG S3_SECRET_KEY
RUN echo "[default]" > /root/.s3cfg
RUN echo "access_key = $S3_ACCESS_KEY" >> /root/.s3cfg
RUN echo "secret_key = $S3_SECRET_KEY" >> /root/.s3cfg
RUN echo "host_base = nyc3.digitaloceanspaces.com" >> /root/.s3cfg
RUN echo "host_bucket = %(bucket)s.nyc3.digitaloceanspaces.com" >> /root/.s3cfg

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py /app/
COPY my-cron-job /etc/cron.d/
#COPY .s3cfg /root/.s3cfg
RUN chmod 600 /root/.s3cfg
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN touch /var/log/testlog.log

RUN echo "*/1 * * * * root /usr/local/bin/python /app/app.py >> /var/log/testlog.log 2>&1 && s3cmd put /var/log/testlog.log s3://testpipeline/Dockerlogs/dockerlogs.log" > /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN crontab /etc/cron.d/my-cron-job

CMD cron && tail -f /var/log/testlog.log