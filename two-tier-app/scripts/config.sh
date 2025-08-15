#!/bin/bash

set -e

# Environment Variables
AWS_REGION="us-east-1"
S3_BUCKET_NAME="pravesh-tf-two-tier-bucket"
DYNAMODB_TABLE_NAME="pravesh-state-table" 
STATE_KEY="terraform/terraform.tfstate" 

echo "--- Creating AWS Resources for Terraform Backend ---"
echo ""

# 1. Create S3 Bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME in region $AWS_REGION..."
aws s3api create-bucket \
    --bucket "$S3_BUCKET_NAME" \
    --region "$AWS_REGION"

echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
    --bucket "$S3_BUCKET_NAME" \
    --versioning-configuration Status=Enabled

echo "S3 bucket created and versioning enabled."
echo ""

# 2. Create DynamoDB Table for State Locking
echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME..."
aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region "$AWS_REGION"

echo "DynamoDB table created for state locking."
echo ""
