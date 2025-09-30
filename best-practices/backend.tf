# 2. Saving State file at Remote Location (S3)

terraform {
  backend "s3" {
    bucket         = "my-pravesh-terraform-state-bucket-2025"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    encrypt  = true
    use_lockfile = true
  }
}
