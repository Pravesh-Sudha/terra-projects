# Create an ECS Cluster
resource "aws_ecs_cluster" "cognee_cluster" {
  name = "cognee-cluster"
  tags = {
    Name = "cognee-cluster"
  }
}

# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "cogneeEcsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the ECS task execution policy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an ECS Task Definition
resource "aws_ecs_task_definition" "cognee_task" {
  family                   = "cognee-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" 
  memory                   = "4096" 
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture       = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "cognee"
      image     = "pravesh2003/cognee-starter-flask:v1"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
  tags = {
    Name = "cognee-task"
  }
}

# Create an ECS Service
resource "aws_ecs_service" "cognee_service" {
  name            = "cognee-service"
  cluster         = aws_ecs_cluster.cognee_cluster.id
  task_definition = aws_ecs_task_definition.cognee_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.cognee_ecs_sg.id]
    assign_public_ip = true
  }
  tags = {
    Name = "cognee-service"
  }
}