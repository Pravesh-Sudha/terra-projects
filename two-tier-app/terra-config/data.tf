data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = "employee-mgnt/rds-credentials"  
}

locals {
  userdata = templatefile("${path.module}/userdata.tpl", {
    DB_NAME     = "employee_db"
    DB_USER     = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["username"]
    DB_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
    DB_PORT     = "3306"
    DB_HOST = aws_db_instance.rds_instance.endpoint
  })
}