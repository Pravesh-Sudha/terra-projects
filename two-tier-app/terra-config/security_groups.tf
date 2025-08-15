# Load-Balancer Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb_sg"
  description = "Allow HTTP/HTTPS access from Internet"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_http_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_https_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Frontend (Application) Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app_sg"
  description = "Allow port 8000 access from ALB only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "app_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_sg_from_alb" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8000
  ip_protocol                  = "tcp"
  to_port                      = 8000
}

resource "aws_vpc_security_group_egress_rule" "app_sg_to_rds" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Database (Backend) Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds_sg"
  description = "Allow port 3306 access from App SG only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rds_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_sg_from_app" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "rds_sg_egress" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}