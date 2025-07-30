terraform {
  backend "s3" {
    bucket         = "pravesh-terraform-state-bucket-2025"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

