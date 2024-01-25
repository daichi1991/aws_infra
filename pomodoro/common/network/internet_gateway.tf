resource "aws_internet_gateway" "pomodoro_backend" {
  vpc_id = aws_vpc.pomodoro.id

  tags = {
    Name = "pomodoro-backend"
  }
}