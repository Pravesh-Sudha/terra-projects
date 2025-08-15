## Create AWS Secrets for RDS Instance

```bash
aws secretsmanager create-secret \
  --name "employee-mgnt/rds-credentials" \
  --secret-string '{"username":"admin","password":"admin1234"}' \
  --region us-east-1
```

## Create Policy for IAM User

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

## Attach the Policy to user
```bash
aws iam attach-user-policy --user-name light --policy-arn arn:aws:iam::<account-id>:policy/TerraformSecretsRead
```
