# Traditional ECS Deployment

This directory contains the **Traditional ECS** implementation of the Flask portfolio application using Terraform.

The purpose is to demonstrate the lower-level ECS approach where the infrastructure and container configuration are explicitly defined rather than relying on ECS Express Mode abstractions.

## Architecture

```text
                    Docker Hub
                        |
                 Flask Portfolio
                      v1/v2/v3
                        |
                        v
                 ECS Cluster
                        |
                     Service
                        |
                     Fargate
                        |
                 ECS Task / ENI
                        |
                  Security Group
                        |
                  Port 5000
                        |
                 Public Task IP
```

This implementation intentionally keeps the architecture simple so that the difference from ECS Express Mode is easy to understand.

The deployed task exposes the Flask application on **port 5000**.

## Files

```text
traditional/
├── ecs.tf
├── get_ip.sh
├── main.tf
├── values.tf
└── README.md
```

### `main.tf`

Contains the core Terraform/provider and infrastructure configuration used by the deployment.

### `ecs.tf`

Contains the ECS-related resources, including the ECS task/service configuration and container definition.

The application container runs on Fargate and listens on:

```text
5000
```

### `values.tf`

Contains configurable values used by the Terraform configuration, such as deployment-specific settings and container image configuration.

### `get_ip.sh`

A helper script that uses AWS CLI commands to retrieve the public IP associated with the running task's network interface.

The resulting address can be used to access:

```text
http://<PUBLIC-IP>:5000
```

Make it executable if necessary:

```bash
chmod +x get_ip.sh
```

Then run:

```bash
./get_ip.sh
```

## Prerequisites

- AWS CLI configured
- Terraform installed
- Docker image available from Docker Hub
- AWS permissions for ECS, IAM, EC2 networking, and related resources

The application image used for this project is:

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

After Terraform finishes:

```bash
./get_ip.sh
```

Open the returned address in your browser.

## Updating the Application Version

This project also demonstrates an application version update through Terraform.

For example, the initial deployment may use:

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

The ECS service will deploy the updated container version.

You can repeat this for:

```text
v1 → v2 → v3
```

The portfolio application intentionally has visible differences between these versions so the deployment update can be demonstrated from the browser.

## Why Traditional ECS?

Traditional ECS exposes more of the underlying architecture.

You are responsible for understanding and configuring the individual pieces rather than simply providing an application image and letting a higher-level service create the supporting infrastructure.

This makes it a useful approach for:

- Learning ECS fundamentals
- Understanding task definitions and services
- Understanding networking
- Controlling individual AWS resources
- Building customized ECS architectures

## Traditional ECS vs Express Mode

Traditional ECS requires more configuration, but that additional configuration provides greater visibility and control.

In this project, the Traditional ECS implementation is deliberately kept explicit so it can be compared directly with the `express/` implementation.

## Cleanup

When finished:

```bash
terraform destroy
```

This is especially important for AWS resources that can incur ongoing charges.
