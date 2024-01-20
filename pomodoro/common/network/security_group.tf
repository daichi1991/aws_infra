resource "aws_security_group" "pomodoro_ecr" {
  vpc_id      = aws_vpc.pomodoro.id
  name        = "pomodoro-ecr"
  description = "pomodoro-ecr traffic"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.5.16.0/20"] // pomodoro
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pomodoro-ecr"
  }
}

resource "aws_security_group" "pomodoro_secretsmanager" {
  vpc_id      = aws_vpc.pomodoro.id
  name        = "pomodoro-secretsmanager"
  description = "pomodoro-secretsmanager traffic"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.5.16.0/20"] // pomodoro
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pomodoro-secretsmanager"
  }
}

resource "aws_security_group" "pomodoro_logs" {
  vpc_id      = aws_vpc.pomodoro.id
  name        = "pomodoro-logs"
  description = "pomodoro-logs traffic"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.5.16.0/20"] // pomodoro
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pomodoro-logs"
  }
}

# resource "aws_security_group" "pomodoro_xray" {
#   vpc_id      = aws_vpc.pomodoro.id
#   name        = "pomodoro-xray"
#   description = "pomodoro-xray traffic"

#   ingress {
#     from_port   = "80"
#     to_port     = "80"
#     protocol    = "tcp"
#     cidr_blocks = ["10.5.16.0/20"] // pomodoro
#   }

#   ingress {
#     from_port   = "443"
#     to_port     = "443"
#     protocol    = "tcp"
#     cidr_blocks = ["10.5.16.0/20"] // pomodoro
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "pomodoro-xray"
#   }
# }
