resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.app_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(local.userdata)

}

resource "aws_autoscaling_group" "app-ag" {
  name                = "${var.project_name}-ag"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]

  # Tie ASG health to ALB checks
  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }
}
