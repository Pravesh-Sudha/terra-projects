# Understanding Terraform State: Local vs Remote (S3 + DynamoDB)

This project demonstrates how Terraform manages state files and the importance of shifting from local to remote backend for secure, collaborative, and scalable infrastructure as code management.

In this guide, you'll learn:
- What is `terraform.tfstate` and why it matters
- Problems with keeping the state file locally
- How to configure remote state backend using **AWS S3** and **DynamoDB**
- How to clean up resources after use

📖 **Read the full blog here**:  
👉 [Managing Terraform State File: Local vs Remote (S3 + DynamoDB)](https://dev.to/aws-builders/managing-terraform-state-file-local-vs-remote-s3-dynamodb-31eg)

---

## 🚀 Prerequisites

- AWS account with an IAM user having EC2 Full Access
- AWS CLI installed and configured
- Terraform installed on your machine

---

## 📁 Project Structure

```

basic-terra/
│
├── main.tf                # Terraform config to create EC2 and SG
├── backend-config.tf      # Configuration for S3 + DynamoDB backend
├── variables.tf           # Input variables
├── config.sh              # Creates the S3 + DynamoDB
├── outputs.tf             # Output IPs and details
└── delete.sh              # Script to tear down S3 and DynamoDB

````

---

## 🛠️ Commands Overview

### Create the Bucket and Table:
```bash
chmod u+x config.sh
./config.sh
```

### Initialize Terraform:
```bash
terraform init
````

### Apply Infrastructure:

```bash
terraform apply --auto-approve
```

### Destroy Infrastructure:

```bash
terraform destroy --auto-approve
```

### Cleanup Remote Backend (S3 + DynamoDB):

```bash
chmod +x delete.sh
./delete.sh
```

---

## 📣 Author

**Pravesh Sudha**
DevOps • Cloud • Content

* 🌐 Website: [blog.praveshsudha.com](https://blog.praveshsudha.com)
* 🐦 Twitter/X: [@praveshstwt](https://x.com/praveshstwt)
* 🔗 LinkedIn: [linkedin.com/in/pravesh-sudha](https://www.linkedin.com/in/pravesh-sudha/)
* 📺 YouTube: [@pravesh-sudha](https://www.youtube.com/@pravesh-sudha)

---

## 💡 License

This project is for learning and demonstration purposes. Feel free to modify and use it in your own projects!