#!/bin/bash
REGION="us-east-1"
CLUSTER="cognee-cluster"
SERVICE="cognee-service"

# Get task ARN
TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER --service-name $SERVICE --region $REGION --query 'taskArns[0]' --output text)

if [ -z "$TASK_ARN" ]; then
  echo "No running tasks found in service $SERVICE"
  exit 1
fi

# Get network interface ID
ENI_ID=$(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK_ARN --region $REGION --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text)

if [ -z "$ENI_ID" ]; then
  echo "No network interface found for task $TASK_ARN"
  exit 1
fi

# Get public IP
PUBLIC_IP=$(aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID --region $REGION --query 'NetworkInterfaces[0].Association.PublicIp' --output text)

if [ -z "$PUBLIC_IP" ]; then
  echo "No public IP assigned to task"
  exit 1
fi

echo "Public IP: $PUBLIC_IP"
echo "Access cognee at: http://$PUBLIC_IP:5000"