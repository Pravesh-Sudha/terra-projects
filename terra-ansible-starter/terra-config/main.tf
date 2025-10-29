# Key-Pair for Ansible
resource "aws_key_pair" "tester_key" {
  key_name   = "tester-key"
  public_key = file("~/.ssh/appKey.pub")
}

# Security Group for EC2
resource "aws_security_group" "tester_sg" {
  name        = "tester_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.app_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tester_sg_ipv4" {
  security_group_id = aws_security_group.tester_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "tester_sg_ipv4_ssh" {
  security_group_id = aws_security_group.tester_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tester_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

# Ec2 Instances
resource "aws_instance" "tester_1" {
    
  for_each = {
    for inst in local.instances : inst.name => inst.env
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name    = aws_key_pair.tester_key.key_name
  vpc_security_group_ids = [aws_security_group.tester_sg.id]

  tags = {
    Name        = each.key
    Environment = each.value
  }
}