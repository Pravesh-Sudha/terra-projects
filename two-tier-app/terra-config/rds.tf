resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets
  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }

}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 20
  db_name                = "employee_db"
  identifier             = "${var.project_name}-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false
}