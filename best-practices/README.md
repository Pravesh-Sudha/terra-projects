
# 🔒 Terraform Security Best Practices Demo

This project demonstrates **5 essential Terraform security best practices** with a hands-on implementation.  
We create an **EC2 instance** on AWS while securing the Terraform workflow using S3 as a remote backend, IAM policies with the **Principle of Least Privilege (PLoP)**, and `terrascan` for scanning misconfigurations.

---

## 📂 Project Structure

```
|
├── main.tf      # Defines AWS provider, IAM roles, EC2 instance & IAM policies (PLoP)
└── backend.tf   # Defines Terraform remote backend in S3 with encryption & locking

```

---

## ⚙️ Features Implemented

1. **Remote Backend with S3** – Stores Terraform state securely.  
2. **State File Encryption** – Protects sensitive data at rest.  
3. **Version Pinning** – Ensures Terraform and provider versions are locked.  
4. **Terrascan Security Scan** – Detects misconfigurations in IaC code.  
5. **Principle of Least Privilege (PLoP)** – EC2 IAM Role has only read access to the state file.  

---

## 🚀 Getting Started

### 1️⃣ Clone the Repo
```bash
git clone https://github.com/Pravesh-Sudha/terra-projects.git
cd terra-projects/best-practices/
````

### 2️⃣ Create S3 Bucket for Remote State

```bash
aws s3 mb s3://my-pravesh-terraform-state-bucket-2025
```

### 3️⃣ Initialize Terraform

```bash
terraform init --upgrade
```

### 4️⃣ Plan & Apply Infrastructure

```bash
terraform plan
terraform apply --auto-approve
```

This will create:

* An **IAM Policy & Role** for EC2.
* An **Instance Profile**.
* An **EC2 Instance** (`t2.micro`) with PLoP attached.

---

## 🔑 Requirements

* Terraform CLI **v1.9.0+**
* AWS CLI configured (`aws configure`)
* An existing **SSH key** in AWS (`default-ec2`)
* Port **22 open** in default security group (for SSH access)

---

## 🛠️ Practical Demonstration

Once deployed, connect to your EC2 instance:

```bash
ssh -i default-ec2.pem ubuntu@<ec2-public-ip>
```

Install AWS CLI:

```bash
sudo apt update && sudo apt install awscli -y
```

Test access:

```bash
aws s3 ls s3://my-pravesh-terraform-state-bucket-2025/terraform
```

Try deleting the state file:

```bash
aws s3 rm s3://my-pravesh-terraform-state-bucket-2025/terraform/terraform.tfstate
```

➡️ You’ll get **AccessDenied**, proving **PLoP** works.

---

## 🔍 Security Scanning with Terrascan

Install [Terrascan](https://github.com/tenable/terrascan#install) and run:

```bash
terrascan scan -f main.tf
```

---

## 📦 State Management Example

Rename resources safely:

```bash
terraform state mv aws_instance.web_server aws_instance.app_server
```

---

## 🏁 Conclusion

This demo shows how to:

* Use **secure backends**
* Apply **IAM least privilege**
* Run **IaC scans**
* Manage **Terraform state responsibly**

---

## 👨‍💻 Author

**Pravesh Sudha**

* 🌐 [Blog](https://blog.praveshsudha.com)
* 💼 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha/)
* 🐦 [Twitter/X](https://x.com/praveshstwt)
* 🎥 [YouTube](https://www.youtube.com/@pravesh-sudha)
