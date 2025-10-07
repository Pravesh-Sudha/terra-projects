# 🌐 Pravesh Sudha Portfolio Web App Deployment

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D%201.5.0-blue?logo=terraform)](https://www.terraform.io/)

This project demonstrates how to use **Terraform modules** to deploy a simple, real-world web application on AWS. It provisions a VPC, an EC2 instance running an Apache web server, and a security group to serve a custom portfolio webpage for **Pravesh Sudha**, a DevOps Engineer and AWS Community Builder. The setup is beginner-friendly, modular, and mirrors how teams deploy public-facing personal or professional webpages in production.

🚀 **Why build this?** Learn Terraform module basics while deploying a professional portfolio webpage accessible via a browser. Perfect for beginners exploring Infrastructure as Code (IaC) and aspiring DevOps engineers!

## 📂 Project Overview

- **Goal**: Deploy a web server hosting Pravesh Sudha's portfolio webpage (`index.html`) on AWS, showcasing achievements and expertise in DevOps and cloud computing.
- **Components**:
  - **VPC Module**: Creates a VPC with a public subnet, internet gateway, and route table for internet access.
  - **EC2 Module**: Launches an EC2 instance with Apache, serving the `index.html` file.
  - **Security Group Module**: Allows HTTP traffic to the EC2 instance.
- **Real-World Relevance**: Mimics deploying a personal portfolio or professional webpage (e.g., for freelancers, engineers, or open-source contributors) with modular, reusable code.

## 🛠️ Requirements

- **Terraform**: Version ≥ 1.5.0 ([Download](https://www.terraform.io/downloads))
- **AWS CLI**: Version ≥ 2.0 ([Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **AWS Account**: Configured with IAM credentials (`aws configure`).
- **Git**: For cloning the repo ([Download](https://git-scm.com/downloads)).
- **index.html**: Provided in the project folder (contains Pravesh Sudha's portfolio webpage).

**Note**: Use AWS Free Tier to minimize costs (e.g., `t2.micro` instance).

## 📂 Project Structure

```
terra-modules/
├── main.tf               # Root module calling VPC, EC2, and security group modules
├── variables.tf          # Input variables
├── outputs.tf            # Outputs (e.g., EC2 public IP)
├── index.html            # Pravesh Sudha's portfolio webpage
├── modules/
│   ├── vpc/              # VPC, public subnet, internet gateway, route table
│   ├── ec2/              # EC2 instance with Apache
│   ├── security-group/   # HTTP access rules
```

## 🚀 Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Pravesh-Sudha/terra-projects.git
   cd terra-projects/terra-modules
   ```

2. **Ensure `index.html` is Present**:
   - The provided `index.html` file (Pravesh Sudha's portfolio webpage) should be in the `terra-modules/` directory.
   - If missing, copy the HTML content from the project documentation or recreate it with Pravesh Sudha's portfolio details.

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Review and Apply**:
   ```bash
   terraform plan
   terraform apply
   ```
   - Approve the changes when prompted.
   - **Note**: Replace the default `ami_id` in `variables.tf` with a valid Amazon Linux 2 AMI for your region (e.g., find via AWS Console).

5. **Access the Webpage**:
   - After `apply`, note the `web_server_ip` output.
   - Visit `http://<web_server_ip>` in a browser to see Pravesh Sudha's portfolio webpage.

6. **Clean Up**:
   ```bash
   terraform destroy
   ```
   - Prevents unwanted AWS charges.

## 🖼️ Expected Result

The browser should display Pravesh Sudha's portfolio webpage with:
- A gradient title: "👨‍💻 Pravesh Sudha"
- Slogan: "DevOps Engineer | AWS Community Builder | Open Source Enthusiast"
- Achievements: Highlights like CI/CD guides, open-source contributions, and AWS certifications
- Modern, tech-focused design with neon highlights and social links

![Pravesh Sudha Portfolio Webpage](screenshots/pravesh-sudha-webpage.png) *(Add a screenshot here)*

## 📚 Learning Goals

- **Terraform Modules**: Understand how to organize infrastructure into reusable modules (VPC, EC2, security group).
- **Real-World Deployment**: Deploy a personal portfolio webpage, mimicking professional or freelance site launches.
- **Networking Basics**: Learn about public subnets, internet gateways, and route tables for internet access.
- **Automation**: Use `user_data` to automate web server setup.
- **Troubleshooting**: Debug common issues like AMI mismatches or security group errors.

## 💡 Real-World Relevance

This setup reflects how professionals deploy portfolio or personal webpages in production:
- **Modular Design**: Reusable modules (e.g., VPC) mirror industry practices for scalable IaC.
- **Public Access**: Public subnets, internet gateways, and route tables are standard for web apps.
- **Portfolio Webpage**: The Pravesh Sudha page mimics real-world use cases like showcasing skills for job applications, freelance gigs, or open-source branding.
- **Extensibility**: Easily extend to add load balancers, domains (Route 53), or static file storage (S3).

## 🛠️ Troubleshooting

- **Webpage Not Loading**:
  - Verify the EC2 instance has a public IP (check `map_public_ip_on_launch` in VPC module).
  - Ensure the security group allows HTTP (port 80) from `0.0.0.0/0`.
  - Confirm the AMI ID is valid for your region (update `variables.tf`).
- **Terraform Errors**:
  - Run `terraform validate` to check syntax.
  - Ensure AWS credentials have permissions (e.g., EC2, VPC, IAM).

## 🔧 Extending the Project

Try these beginner-friendly tweaks:
- **Customize the Webpage**: Edit `index.html` to update achievements, colors, or links, then re-run `terraform apply`.
- **Add Another Instance**: Call the `ec2` module again with a different `app_name` to deploy a second web server.
- **Explore S3**: Modify the EC2 module to serve `index.html` from an S3 bucket instead.

## 📄 License

MIT License - see [LICENSE](../LICENSE) for details.

## 👨‍💻 Author

**Pravesh Sudha**  
- GitHub: [@Pravesh-Sudha](https://github.com/Pravesh-Sudha)
- LinkedIn: [Pravesh Sudha](https://www.linkedin.com/in/pravesh-sudha-82a37422a/)
- Twitter/X: [@praveshstwt](https://twitter.com/praveshstwt)
- Website: [praveshsudha.com](https://praveshsudha.com/)
- YouTube: [@pravesh-sudha](https://www.youtube.com/@pravesh-sudha)
- Blog: [blog.praveshsudha.com](https://blog.praveshsudha.com/)

Star the repo if you find this useful! Share your builds or questions with me.

---

*Built with ❤️ for the Terraform community. Last updated: October 2025*
