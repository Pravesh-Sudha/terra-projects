# ECS Express Mode Deployment

This directory contains the **Amazon ECS Express Mode** implementation of the Flask portfolio application using Terraform.

The goal is to demonstrate how ECS Express Mode reduces the amount of infrastructure configuration required compared with Traditional ECS.

## Architecture

```text
                    Docker Hub
                        |
                 Flask Portfolio
                      v1/v2/v3
                        |
                        v
                ECS Express Mode
                        |
          +-------------+-------------+
          |                           |
          v                           v
   Application Load              Target Group
      Balancer                        |
          |                           |
          +-------------+-------------+
                        |
                     Fargate
                        |
                   Flask Task
                    Port 5000
```

Instead of manually creating and wiring every supporting resource, Express Mode uses a higher-level service definition and an infrastructure role to provision and manage the supporting infrastructure for the application.

## Files

```text
express/
├── express.tf
├── iam.tf
├── outputs.tf
├── provider.tf
├── vars.tf
└── README.md
```

### `express.tf`

Contains the ECS Express Mode service configuration.

The primary container runs the Flask portfolio application on:

```text
port 5000
```

The container image is configurable so different application versions can be deployed.

### `iam.tf`

Contains the IAM configuration required by the ECS Express Mode deployment.

The infrastructure role allows ECS Express Mode to provision and manage the infrastructure required by the service.

### `outputs.tf`

Contains Terraform outputs useful after deployment, such as service-related information and the application endpoint.

### `provider.tf`

Defines the Terraform AWS provider configuration.

### `vars.tf`

Contains variables used to configure the Express Mode deployment.

## Prerequisites

- AWS CLI configured
- Terraform installed
- AWS permissions for ECS Express Mode and the required supporting resources
- Docker image available from Docker Hub

The application image used in this project is:

```text
pravesh2003/flask-portfolio:v1
```

The image is built for:

```text
linux/amd64
```

## Deploy

From this directory:

```bash
terraform init
terraform plan
terraform apply
```

Terraform will create the ECS Express Mode service and the supporting infrastructure required by the service.

After deployment, use the Terraform outputs to find the application endpoint:

```bash
terraform output
```

## Updating the Application Version

The project demonstrates application updates by changing the container image tag.

For example:

```hcl
image = "pravesh2003/flask-portfolio:v1"
```

Change it to:

```hcl
image = "pravesh2003/flask-portfolio:v2"
```

Then:

```bash
terraform plan
terraform apply
```

The same process can be repeated:

```text
v1 → v2 → v3
```

The application versions represent:

| Version | Stage | Purpose |
|---|---|---|
| `v1` | Foundation | Initial portfolio |
| `v2` | Advanced | Expanded portfolio capabilities |
| `v3` | Production | Final polished version |

This provides a visible demonstration of an application version rollout using Terraform.

## What Express Mode Abstracts

One of the main reasons for this experiment is to understand what ECS Express Mode takes care of for you.

Depending on the service configuration, Express Mode can provision and manage supporting components such as:

- Application Load Balancer
- Target group
- Security groups
- Networking configuration
- Service scaling
- CloudWatch metrics and alarms
- ECS service/task infrastructure

This means you can focus more on the **application and its deployment configuration** rather than manually wiring every supporting resource.

## Why ECS Express Mode?

Express Mode is useful when:

- You want to deploy a containerized application quickly
- You don't need fine-grained control over every supporting resource
- You are new to ECS
- You want a simpler deployment experience
- You want AWS to manage more of the underlying service infrastructure

The trade-off is that you give up some of the explicit control available with Traditional ECS.

## Express Mode vs Traditional ECS

The same Flask application is deployed in both directories.

The key difference is the level of abstraction:

```text
Traditional ECS
    ↓
More configuration
    ↓
More control
    ↓
More ECS concepts to understand


ECS Express Mode
    ↓
Less configuration
    ↓
More AWS-managed infrastructure
    ↓
Faster application deployment
```

This project is intentionally designed to make that difference observable rather than purely theoretical.

## Cleanup

When finished:

```bash
terraform destroy
```

Make sure you destroy the deployment when you are no longer experimenting with it to avoid unnecessary AWS charges.
