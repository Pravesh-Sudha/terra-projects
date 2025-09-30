# 🌍 Terraform Projects by Pravesh Sudha

This repository is a collection of Terraform projects that showcase **Infrastructure as Code (IaC)** best practices, real-world use cases, and security-first approaches for deploying applications and managing cloud resources on AWS.

---

## 📂 Projects

### 1️⃣ terraform-security-best-practices
A demo project showcasing **5 essential security best practices** for Terraform:
- Remote backend with **S3**
- **Encrypted** state file storage
- **Provider version pinning**
- **Principle of Least Privilege (PLoP)** with IAM roles & policies
- **Terrascan** integration for security scanning

🔑 Learn how to secure Terraform workflows with real-world examples.

---

### 2️⃣ two-tier-app
A production-style **Flask + AWS RDS** employee management application deployed using Terraform:
- **Highly available** two-tier architecture
- **Secure** deployment with isolated subnets
- **Scalable** design for application + database layers
- IAM roles, security groups, and networking best practices baked in

🚀 Great for learning **application + database provisioning with Terraform**.

---

### 3️⃣ basic-terra
A beginner-friendly project demonstrating:
- How **remote hosting of Terraform state files** can lead to issues if not managed securely
- Misconfiguration scenarios and **why state management matters**
- Simple AWS infrastructure example to illustrate concepts

📘 A foundational project for understanding **Terraform state file management**.

---

## 🛠️ Requirements

To run these projects locally, make sure you have:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) **v1.9.0+**
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured (`aws configure`)
- An AWS account with necessary permissions

---

## 🚀 Getting Started

Clone the repo:
```bash
git clone https://github.com/Pravesh-Sudha/terra-projects.git
cd terra-projects
```

Pick a project and follow its individual `README.md`.

Example:

```bash
cd best-practices
terraform init
terraform plan
terraform apply --auto-approve
```

---

## 📚 Learning Goals

Through these projects, you will:

* Understand **Terraform fundamentals**
* Learn **secure IaC practices**
* Deploy real-world applications with **AWS services**
* Gain experience in **Terraform state management**

---

## 👨‍💻 Author

**Pravesh Sudha**

* 🌐 [Blog](https://blog.praveshsudha.com)
* 💼 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha/)
* 🐦 [Twitter/X](https://x.com/praveshstwt)
* 🎥 [YouTube](https://www.youtube.com/@pravesh-sudha)