
# FROM python:3.9 AS builder
# COPY /root/.s3cfg /root/.s3cfg

# FROM python:3.9

# RUN apt-get update && apt-get install -y cron s3cmd

# WORKDIR /app

# COPY requirements.txt .
# RUN pip install -r requirements.txt

# COPY app.py /app/
# COPY my-cron-job /etc/cron.d/

# RUN chmod 0644 /etc/cron.d/my-cron-job
# RUN touch /var/log/testlog.log
# # USER root
# # ARG S3CFG_LOCATION=/root/.s3cfg
# # COPY $S3CFG_LOCATION /root/.s3cfg
# #docker exec 4f1608d5970b s3cmd --access_key=DO00QTR2VTHEK2R9URFJ --secret_key=<Qrv4BQUStDQCCQ0wR97WvS0TDtrHGyJwChEet11Cu70 --endpoint-url=https://https://testpipeline.nyc3.digitaloceanspaces.com put /var/log/testing.log s3://testingpipeline4536/logs/test.log

# RUN echo "*/1 * * * * root /usr/local/bin/python /app/app.py >> /var/log/testlog.log 2>&1 && s3cmd --access_key=DO00QTR2VTHEK2R9URFJ --secret_key=Qrv4BQUStDQCCQ0wR97WvS0TDtrHGyJwChEet11Cu70 --endpoint-url=https://testpipeline.nyc3.digitaloceanspaces.com put /var/log/testlog.log s3://testingpipeline4536/logs/" > /etc/cron.d/my-cron-job
# RUN chmod 0644 /etc/cron.d/my-cron-job
# RUN crontab /etc/cron.d/my-cron-job

# CMD cron && tail -f /var/log/testlog.log


FROM python:3.9

# Set the working directory for the application
WORKDIR /app

# Install the aws-cli tool
RUN apt-get update && apt-get install -y awscli

# Set the AWS access key and secret key as environment variables
# ENV AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}
# ENV AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}

# Copy the application files to the container
COPY app.py requirements.txt ./
RUN pip install -r requirements.txt

# Add a cron job to upload the logs to DigitalOcean Spaces
RUN echo "*/1 * * * * aws s3 cp /var/log/myapp.log s3://testpipeline/DcokerLogs --endpoint-url=https://testpipeline.nyc3.digitaloceanspaces.com" > /etc/cron.d/myapp
RUN chmod 0644 /etc/cron.d/myapp

# Start the cron daemon and the Flask application
CMD cron && python app.py
