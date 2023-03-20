FROM python:3.9

RUN apt-get update && apt-get install -y cron

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py /app/
COPY my-cron-job /etc/cron.d/

RUN chmod 0644 /etc/cron.d/my-cron-job
RUN touch /var/log/cron.log

RUN echo "*/1 * * * * root /usr/local/bin/python /app/app.py >> /var/log/cron.log 2>&1" > /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN crontab /etc/cron.d/my-cron-job

CMD cron && tail -f /var/log/cron.log
