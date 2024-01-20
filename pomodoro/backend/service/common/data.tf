data "aws_caller_identity" "current" {}

data "aws_vpc" "pomodoro_vpc" {
  tags = {
    Name = "pomodoro"
  }
}
