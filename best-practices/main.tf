# 1. Terraform Modules and Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 3. Scan the Terraform config using TerraScan
# Use this command: terrascan -f main.tf

# -----------------------
# 4. use PLoP (Principle of Least Privilege) 
# -----------------------

## Create the Policy Doc
data "aws_iam_policy_document" "s3_state_access_doc" {
  statement {
    sid    = "AllowListAndLocation"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::my-pravesh-terraform-state-bucket-2025"]
  }

  statement {
    sid    = "AllowReadStateFile"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::my-pravesh-terraform-state-bucket-2025/terraform/terraform.tfstate"]
  }
}

## Create the IAM Policy
resource "aws_iam_policy" "s3_state_access_policy" {
  name        = "EC2-S3-State-Read-Policy"
  description = "Policy for EC2 to read the Terraform state file."
  policy      = data.aws_iam_policy_document.s3_state_access_doc.json
}

## Create The IAM Role
resource "aws_iam_role" "ec2_s3_role" {
  name               = "EC2-S3-State-Reader-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Sid = ""
      },
    ],
  })
}

## Attach the Policy to the Role 
resource "aws_iam_role_policy_attachment" "s3_state_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_state_access_policy.arn
}

# Create the Instance Profile 
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "EC2-S3-State-Reader-Profile"
  role = aws_iam_role.ec2_s3_role.name
}

## Get Ubuntu AMI
data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["amazon"]
  
      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }

## Create Ec2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "default-ec2" # <<-- UPDATE THIS
  
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name = "testing-instance"
  }
}