terraform {
  backend "s3" {
    bucket       = "pravesh-tf-two-tier-bucket"
    key          = "terraform/terrform.tfstate"
    region       = "us-east-1"
    dynamodb_table = "pravesh-state-table"
    encrypt       =  true 
  }
}
