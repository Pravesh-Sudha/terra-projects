#!/bin/bash

set -e
export DEBIAN_FRONTEND=noninteractive

# basic deps
apt-get update -y
apt-get install -y git python3 python3-pip python3-venv mysql-client libmysqlclient-dev build-essential pkg-config

# export DB env variables (inherited by processes started below)
export DB_NAME="${DB_NAME}"
export DB_USER="${DB_USER}"
export DB_PASSWORD="${DB_PASSWORD}"
export DB_HOST="${DB_HOST}"
export DB_PORT="3306"

echo "DB_NAME=$DB_NAME" >> /home/ubuntu/userdata.log
echo "DB_USER=$DB_USER" >> /home/ubuntu/userdata.log
echo "DB_PASSWORD=$DB_PASSWORD" >> /home/ubuntu/userdata.log
echo "DB_HOST=$DB_HOST" >> /home/ubuntu/userdata.log
echo "DB_PORT=$DB_PORT" >> /home/ubuntu/userdata.log

# Create database if it doesn't exist
mysql -h "$(echo ${DB_HOST} | cut -d : -f1)" -u "${DB_USER}" -p"${DB_PASSWORD}" -P "${DB_PORT}" -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};" 2>> /home/ubuntu/userdata.log

# Remove existing /home/ubuntu/app directory if it exists
if [ -d "/home/ubuntu/app" ]; then
  rm -rf /home/ubuntu/app
fi

# Clone & install app
git clone https://github.com/Pravesh-Sudha/employee_management.git /home/ubuntu/app 2>> /home/ubuntu/userdata.log
cd /home/ubuntu/app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt 2>> /home/ubuntu/userdata.log

chown -R ubuntu:ubuntu /home/ubuntu/app


# Small randomized sleep to reduce concurrent migrations
sleep $((RANDOM % 10))

# Retry migrations (5 attempts)
attempt=0
until [ $attempt -ge 5 ]
do
  attempt=$((attempt+1))
  echo "Running migrations (attempt $attempt)..." tee -a /home/ubuntu/userdata.log
  python manage.py migrate --noinput >> /home/ubuntu/migrate.log 2>&1 && break
  echo "Migrate failed, retrying in 5s..." | tee -a /home/ubuntu/userdata.log
  sleep 5
done

# start gunicorn
nohup /home/ubuntu/app/venv/bin/gunicorn --workers 2 --timeout 60 --access-logfile /home/ubuntu/gunicorn-access.log --error-logfile /home/ubuntu/gunicorn-error.log employee_management.wsgi:application --bind 0.0.0.0:8000 &

# Done
echo "user-data finished"