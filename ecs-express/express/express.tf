resource "aws_ecs_express_gateway_service" "portfolio" {
  service_name = "portfolio-express"

  execution_role_arn      = aws_iam_role.ecs_execution_role.arn
  infrastructure_role_arn = aws_iam_role.ecs_infrastructure_role.arn

  primary_container {
    image          = "docker.io/pravesh2003/flask-portfolio:v1"
    container_port = 5000
  }

  network_configuration {
    subnets = data.aws_subnets.default.ids
  }

  tags = {
    Name        = "portfolio-express"
    Environment = "experiment"
    Project     = "ecs-express-vs-traditional"
  }

  wait_for_steady_state = true

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_role,
    aws_iam_role_policy_attachment.ecs_infrastructure_role
  ]
}