# ECS ALB
resource "aws_security_group" "prod_pomodoro_backend_alb" {
  vpc_id      = data.aws_vpc.pomodoro.id
  name        = "prod-pomodoro-backend-alb"
  description = "prod-pomodoro-backend-alb inbound traffic"

  dynamic "ingress" {
    for_each = var.ingress_elb_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # ingress {
  #   from_port       = "8080"
  #   to_port         = "8080"
  #   protocol        = "tcp"
  #   description     = "Blue/Green deployment"
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-pomodoro-backend-alb"
  }
}

# ECS Task
resource "aws_security_group" "prod_pomodoro_backend_ecs_task" {
  vpc_id      = data.aws_vpc.pomodoro.id
  name        = "prod-pomodoro-backend-ecs-task"
  description = "prod-pomodoro-backend-ecs-task inbound traffic"

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.prod_pomodoro_backend_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-pomodoro-backend-ecs-task"
  }
}

// db
resource "aws_security_group" "prod_pomodoro_db" {
  vpc_id      = data.aws_vpc.pomodoro.id
  name        = "prod-pomodoro-db"
  description = "prod-pomodoro-db inbound traffic"

  ingress {
    from_port = "5432"
    to_port   = "5432"
    protocol  = "tcp"
    security_groups = [
      aws_security_group.prod_pomodoro_backend_ecs_task.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-pomodoro-db"
  }
}
