resource "aws_internet_gateway" "pomodoro" {
  vpc_id = aws_vpc.pomodoro.id

  tags = {
    Name = "pomodoro"
  }
}