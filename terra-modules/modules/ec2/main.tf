data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              apt get update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              cat > /var/www/html/index.html <<EOT
              ${file("${path.module}/index.html")}
              EOT
              EOF


  tags = {
    Name = "${var.app_name}-instance"
  }
}