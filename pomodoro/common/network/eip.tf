resource "aws_eip" "prod_pomodoro_backend_eip" {
  tags = {
    Name = "prod-pomodoro-backend"
  }
}
