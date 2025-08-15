## Create AWS Secrets for RDS Instance

```bash
aws secretsmanager create-secret \
  --name "employee-mgnt/rds-credentials" \
  --secret-string '{"username":"admin","password":"admin1234"}' \
  --region us-east-1
```



