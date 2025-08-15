# Employee Management Application Deployment with Terraform

This project deploys a two-tier application architecture on AWS using Terraform. It includes an Auto Scaling Group (ASG) of EC2 instances running a Django-based employee management application (cloned from https://github.com/Pravesh-Sudha/employee_management.git), a MySQL RDS database, an Application Load Balancer (ALB) for traffic distribution, and associated networking and security resources. The application is configured to use Gunicorn on port 8000, with a `/health` endpoint for ALB health checks.

The setup uses a modular structure with a `terra-config` directory for Terraform files and `userdata.tpl` for EC2 instance configuration. Secrets Manager is used to securely manage RDS credentials.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Setup](#setup)
  - [Configure Terraform Backend](#configure-terraform-backend)
  - [Configure AWS Secrets Manager](#configure-aws-secrets-manager)
  - [Configure IAM Policy for Terraform](#configure-iam-policy-for-terraform)
- [Deployment](#deployment)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [Social Links](#social-links)

## Prerequisites
- **AWS CLI**: Installed and configured with access keys for an IAM user with sufficient permissions (e.g., AdministratorAccess for simplicity; restrict in production).
- **Terraform**: Installed (version 1.5+ recommended).
- **AWS Account**: With permissions to create EC2, RDS, ALB, VPC, S3, DynamoDB, and Secrets Manager resources.
- **Git**: Installed to clone the Django repository.
- **Key Pair**: Create an EC2 key pair for SSH access if needed (optional for SSM).
- **Region**: us-east-1 (adjust in code if different).

## Setup

### Configure Terraform Backend
To store Terraform state securely, create an S3 bucket and DynamoDB table for locking using the provided script in the `scripts` directory.

Run:
```bash
cd scripts
bash config.sh
```

This creates:
- S3 bucket: `pravesh-tf-two-tier-bucket`
- DynamoDB table: `pravesh-state-table`

Update your Terraform backend configuration in `terra-config/main.tf`:
```hcl
terraform {
  backend "s3" {
    bucket         = "pravesh-tf-two-tier-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pravesh-state-table"
    encrypt        = true
  }
}
```

### Configure AWS Secrets Manager
Create a secret for RDS credentials using AWS CLI:
```bash
aws secretsmanager create-secret \
  --name "employee-mgnt/rds-credentials" \
  --secret-string '{"username":"admin","password":"admin1234"}' \
  --region us-east-1
```

Verify:
```bash
aws secretsmanager get-secret-value \
  --secret-id "employee-mgnt/rds-credentials" \
  --region us-east-1
```

### Configure IAM Policy for Terraform
Create a policy for your IAM user to read Secrets Manager:
```bash
aws iam create-policy --policy-name TerraformSecretsRead --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-1:<account-id>:secret:employee-mgnt/rds-credentials-*"
    }
  ]
}'
```

Attach the policy:
```bash
aws iam attach-user-policy --user-name light --policy-arn arn:aws:iam::<account-id>:policy/TerraformSecretsRead
```

![add and attach policy](<Screenshot 2025-08-15 at 7.32.01 PM.png>)

## Deployment
1. Navigate to the Terraform directory:
   ```bash
   cd terra-config
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply -auto-approve
   ```

The deployment includes:
- VPC with public and private subnets.
- EC2 instances in an ASG running the Django app on Gunicorn (port 8000).
- RDS MySQL instance with `employee_db`.
- ALB forwarding traffic to the ASG.
- Security groups for ALB, EC2, and RDS.

The `userdata.tpl` script on EC2 instances:
- Installs dependencies.
- Fetches RDS credentials from Secrets Manager.
- Clones the GitHub repository.
- Sets up a virtual environment.
- Creates the `employee_db` database.
- Runs migrations.
- Starts Gunicorn.

Example `userdata.tpl` content for reference:
```
#!/bin/bash

set -e
export DEBIAN_FRONTEND=noninteractive

# basic deps
apt-get update -y
apt-get install -y git python3 python3-pip python3-venv mysql-client libmysqlclient-dev build-essential pkg-config

# export DB env variables (inherited by processes started below)
export DB_NAME="${DB_NAME}"
export DB_USER="${DB_USER}"
export DB_PASS="${DB_PASS}"
export DB_HOST="${DB_HOST}"
export DB_PORT="3306"

# Create database if it doesn't exist
mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" -P "${DB_PORT}" -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

# Remove existing /home/ubuntu/app directory if it exists
if [ -d "/home/ubuntu/app" ]; then
  rm -rf /home/ubuntu/app
fi

# Clone & install app
git clone https://github.com/Pravesh-Sudha/employee_management.git /home/ubuntu/app
cd /home/ubuntu/app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

chown -R ubuntu:ubuntu /home/ubuntu/app


# Small randomized sleep to reduce concurrent migrations
sleep $((RANDOM % 10))

# Retry migrations (5 attempts)
attempt=0
until [ $attempt -ge 5 ]
do
  attempt=$((attempt+1))
  echo "Running migrations (attempt $attempt)..."
  python manage.py migrate --noinput && break
  echo "Migrate failed, retrying in 5s..."
  sleep 5
done

# start gunicorn
nohup /home/ubuntu/app/venv/bin/gunicorn employee_management.wsgi:application --bind 0.0.0.0:8000 &

# Done
echo "user-data finished"
```

## Accessing the Application
- Get the ALB DNS name:
  ```bash
  terraform output alb_dns_name
  ```
- Access the application at `http://<alb-dns-name>` (e.g., `employee-mgnt-alb-1234567890.us-east-1.elb.amazonaws.com`).
- Use SSM to access EC2 instances for debugging:
  ```bash
  aws ssm start-session --target <instance-id> --region us-east-1
  ```
- Check logs on EC2:
  ```bash
  cat /var/log/cloud-init-output.log
  cat /home/ubuntu/app/nohup.out
  curl -I http://localhost:8000/health
  ```

## Troubleshooting
- **ALB Health Check Failure**: Check target group status:
  ```bash
  aws elbv2 describe-target-health --target-group-arn <target-group-arn> --region us-east-1
  ```
- **Database Connection Issues**: Verify RDS endpoint and credentials in Secrets Manager.
- **Gunicorn Not Running**: Check `/home/ubuntu/app/nohup.out` for errors.
- **Terraform Errors**: Ensure IAM permissions for Secrets Manager are attached to your user.
- **SSM Agent Not Online**: Ensure EC2 IAM role includes `AmazonSSMManagedInstanceCore` and VPC endpoints or NAT Gateway for private subnets.

## Cleanup
To delete the Terraform backend resources (S3 bucket and DynamoDB table), run the provided script in the `scripts` directory:
```bash
cd scripts
bash delete.sh
```

This empties the S3 bucket (including versions) and deletes the bucket and DynamoDB table. Then, destroy Terraform resources:
```bash
cd terra-config
terraform destroy -auto-approve
```

## Social Links
- LinkedIn: https://www.linkedin.com/in/pravesh-sudha/
- Twitter/X: https://x.com/praveshstwt
- Blog: https://blog.praveshsudha.com/
- Youtube: https://www.youtube.com/@pravesh-sudha