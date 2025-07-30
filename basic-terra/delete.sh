#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# ENV Vars
AWS_REGION="us-east-1"  
S3_BUCKET_NAME="pravesh-terraform-state-bucket-2025"
DYNAMODB_TABLE_NAME="terraform-state-lock" 

echo "--- Deleting AWS Resources for Terraform Backend ---"
echo ""

# 1. Empty the S3 Bucket (including all object versions and delete markers)
echo "Emptying S3 bucket: $S3_BUCKET_NAME (This may take some time for versioned buckets)..."

# List all object versions and delete markers
# Filter out "null" VersionId as it signifies current version if not explicitly versioned.
objects_to_delete=$(aws s3api list-object-versions \
    --bucket "$S3_BUCKET_NAME" \
    --output=json \
    --query='{Objects: Versions[].[Key,VersionId],DeleteMarkers:DeleteMarkers[].[Key,VersionId]}' \
    --region "$AWS_REGION")

# If there are objects or delete markers to delete
if [ "$(echo "$objects_to_delete" | jq '.Objects | length')" -gt 0 ] || \
   [ "$(echo "$objects_to_delete" | jq '.DeleteMarkers | length')" -gt 0 ]; then

    # Convert the JSON output into a format suitable for delete-objects
    delete_payload=$(echo "$objects_to_delete" | jq -c '{Objects: (.Objects + .DeleteMarkers | map({Key: .[0], VersionId: .[1]}) | unique)}')
    
    # Delete all object versions and delete markers
    aws s3api delete-objects \
        --bucket "$S3_BUCKET_NAME" \
        --delete "$delete_payload" \
        --region "$AWS_REGION"
    echo "All objects and delete markers emptied from S3 bucket: $S3_BUCKET_NAME."
else
    echo "S3 bucket '$S3_BUCKET_NAME' is already empty."
fi

# 2. Delete the S3 Bucket
echo "Deleting S3 bucket: $S3_BUCKET_NAME..."
aws s3 rb s3://"$S3_BUCKET_NAME" \
    --region "$AWS_REGION" \
    --force # Force deletion even if it had residual items that weren't caught by the previous step

echo "S3 bucket '$S3_BUCKET_NAME' deleted."
echo ""

# 3. Delete the DynamoDB Table
echo "Deleting DynamoDB table: $DYNAMODB_TABLE_NAME..."
aws dynamodb delete-table \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --region "$AWS_REGION"

echo "DynamoDB table '$DYNAMODB_TABLE_NAME' deleted."
echo ""

echo "Terraform backend resources deleted successfully."
