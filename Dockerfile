
# FROM python:3.8-slim-buster


# WORKDIR /app

# COPY . /app


# RUN pip install -r requirements.txt 

# EXPOSE 80


# ENV NAME World

# CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:80", "app:app"]
FROM python:3.9

RUN apt-get update && apt-get install -y cron

COPY my-cron-job /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job

RUN touch /var/log/cron.log

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENV DIGITALOCEAN_REGISTRY registry.digitalocean.com/testinggitaction
ENV DIGITALOCEAN_REPOSITORY my-flask-app

RUN echo "*/5 * * * * root docker pull ${DIGITALOCEAN_REGISTRY}/${DIGITALOCEAN_REPOSITORY}:latest && docker run --rm ${DIGITALOCEAN_REGISTRY}/${DIGITALOCEAN_REPOSITORY}:latest" > /etc/cron.d/my-cron-job
RUN chmod 0644 /etc/cron.d/my-cron-job
RUN crontab /etc/cron.d/my-cron-job
RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log