# Terraform Workspace S3 Project

This project demonstrates how to use **Terraform Workspaces** to manage multi-environment deployments (Dev, Stage, Prod) and host a **static website** on **AWS S3**.

---

## 🧭 Overview

Terraform Workspaces allow us to manage multiple environments using the same configuration.  
In this project, each environment creates its own S3 bucket and hosts a unique static website.

### Example Bucket Names
- `pravesh-dev-terraform-workspace-site`
- `pravesh-stage-terraform-workspace-site`
- `pravesh-prod-terraform-workspace-site`

Each environment has a distinct `index.html` file to identify which workspace is currently active.

---

## ⚙️ Project Structure

```

terraform-workspace-s3/
│
├── main.tf              # Main configuration file for S3 bucket and website setup
├── provider.tf          # Specifies AWS as provider and region
├── output.tf            # Outputs website URLs for each environment
├── create.sh            # Script to automate workspace creation and deployment
├── delete.sh            # Script to destroy workspaces and clean up resources
│
└── index/
├── dev/index.html
├── stage/index.html
└── prod/index.html

```

---

## 🧑‍💻 Prerequisites

Make sure you have:
- **AWS CLI** installed and configured with an IAM user having S3 full access.
- **Terraform CLI** installed (v1.3+ recommended).

---

## 🚀 How to Run

Clone the repository and navigate into the project folder:

```bash
git clone https://github.com/Pravesh-Sudha/terra-projects.git
cd terra-projects/terraform-workspace-s3
````

Make the shell script executable and run it:

```bash
chmod u+x create.sh
./create.sh
```

This script will:

* Create Terraform workspaces (`dev`, `stage`, `prod`)
* Deploy a static website to AWS S3 for each workspace
* Output the S3 website URLs

You can open the generated URLs in your browser to view the website for each environment.

---

## 🧹 Clean Up

After testing, destroy all resources to avoid unnecessary AWS costs:

```bash
chmod u+x delete.sh
./delete.sh
```

This will delete:

* All created S3 buckets
* Uploaded website files
* Associated Terraform workspaces

---

## 🏁 Conclusion

This project is a simple and practical way to understand how Terraform manages **multi-environment deployments** using **Workspaces**.
It’s an ideal starting point for beginners exploring IaC, AWS S3 automation, or multi-env pipelines.

---

## 🧠 Author

**Pravesh Sudha**
🔗 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha/) | [Twitter](https://x.com/praveshstwt) | [Website](https://blog.praveshsudha.com)

---

## 📄 License

This project is open-source and available under the **MIT License**.