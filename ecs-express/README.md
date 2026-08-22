# ECS Traditional vs ECS Express Mode with Terraform

This project compares two ways of deploying the same containerized Flask portfolio application on Amazon ECS:

- **Traditional ECS** — explicit ECS infrastructure and networking configuration
- **ECS Express Mode** — a higher-level deployment model that abstracts much of the supporting infrastructure

The project is part of my [Terraform Projects](https://github.com/Pravesh-Sudha/terra-projects) repository and is intended as a hands-on comparison of **control vs. abstraction**.

## Architecture

```text
                         Flask Portfolio
                               |
                    Docker image: v1/v2/v3
                               |
                +--------------+--------------+
                |                             |
                v                             v
        Traditional ECS               ECS Express Mode
                |                             |
             Fargate                    Fargate
                |                             |
        Explicit ECS setup          Managed supporting
        and networking              infrastructure
                |                             |
          Direct access /           Load Balancer,
          public task ENI           Target Group,
          via port 5000             scaling, metrics,
                                    alarms, etc.
```

## Project Structure

```text
.
├── express/
│   ├── express.tf
│   ├── iam.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── vars.tf
│   └── README.md
│
├── traditional/
│   ├── ecs.tf
│   ├── get_ip.sh
│   ├── main.tf
│   ├── values.tf
│   └── README.md
│
└── README.md
```

## The Application

Both deployments use the same Flask portfolio application packaged as a Docker image.

The application has three image versions:

```text
pravesh2003/flask-portfolio:v1
pravesh2003/flask-portfolio:v2
pravesh2003/flask-portfolio:v3
```

The versions represent an application progression:

- **v1** — Foundation
- **v2** — Advanced
- **v3** — Production

The image is built for `linux/amd64` so it can be deployed consistently to the ECS environment, even when building from an ARM64/Apple Silicon machine.

## Traditional ECS vs ECS Express Mode

| Area | Traditional ECS | ECS Express Mode |
|---|---|---|
| Abstraction | Lower-level | Higher-level |
| Task/service configuration | Explicit | Simplified |
| Supporting infrastructure | User-managed | Provisioned/managed by Express Mode |
| Load balancer | Configure yourself | Express Mode provisions it |
| Target groups | Configure yourself | Managed as part of the Express service |
| Scaling | Configure yourself | Simplified scaling configuration |
| Learning ECS internals | Excellent | More abstracted |
| Getting started quickly | More work | Much faster |
| Control | Higher | Lower |

The goal is not to prove that one is universally better. Instead, this project demonstrates the trade-off between **simplicity and control**.

## Prerequisites

- AWS account
- AWS CLI configured
- Terraform installed
- Docker installed
- Permissions to create the required ECS, IAM, networking, and supporting AWS resources
- Docker Hub image access

Check your tools:

```bash
terraform version
aws --version
docker --version
```

## Running the Projects

Each implementation is independent.

### Traditional ECS

```bash
cd traditional
terraform init
terraform plan
terraform apply
```

After deployment, use the included `get_ip.sh` script to retrieve the application's accessible IP and port.

See [`traditional/README.md`](traditional/README.md).

### ECS Express Mode

```bash
cd express
terraform init
terraform plan
terraform apply
```

Express Mode provisions the supporting infrastructure required by the service.

See [`express/README.md`](express/README.md).

## Demonstrating Application Updates

One of the demonstrations in this project is updating the application without changing the infrastructure design.

For example, change:

```hcl
image = "pravesh2003/flask-portfolio:v1"
```

to:

```hcl
image = "pravesh2003/flask-portfolio:v2"
```

Then run:

```bash
terraform plan
terraform apply
```

The same process can be repeated for `v3`.

```text
v1  →  v2  →  v3
 |       |       |
Foundation Advanced Production
```

This makes the project useful for demonstrating how an infrastructure-as-code workflow handles application version changes.

## What This Project Demonstrates

### Traditional ECS

- ECS cluster/service/task concepts
- Fargate task configuration
- Container networking
- Security groups
- IAM execution roles
- Public task networking
- Terraform-managed ECS resources

### ECS Express Mode

- Higher-level ECS deployment abstraction
- Infrastructure role
- Simplified container deployment
- Automatically provisioned supporting resources
- Scaling and observability capabilities
- Application version updates through Terraform

## Learning Outcome

The key lesson from this project is:

> **ECS Express Mode reduces the amount of infrastructure you need to manage, while Traditional ECS gives you more direct control over the underlying ECS architecture.**

Express Mode is useful when the priority is **getting a containerized application running quickly with sensible supporting infrastructure**.

Traditional ECS is more appropriate when the goal is **learning ECS deeply or controlling individual infrastructure components**.

## Cleanup

Destroy the resources after experimenting to avoid unnecessary AWS charges:

```bash
terraform destroy
```

Run this separately inside the directory you deployed.

## Author

**Pravesh Sudha**