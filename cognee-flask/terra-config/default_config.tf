data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
      name   = "vpc-id"
      values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "cognee_ecs_sg" {
  name        = "allow-http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "cognee_ecs_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "cognee_ecs_sg_ipv4_for_app" {
  security_group_id = aws_security_group.cognee_ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.cognee_ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}